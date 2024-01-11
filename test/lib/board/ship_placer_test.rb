require 'minitest/autorun'

require './lib/board/ship_placer.rb'
require './lib/board/board.rb'
require './lib/ship.rb'
require './lib/game.rb'

describe ShipPlacer do
  describe '.place_all' do
    it 'it places all ships' do
      skip
      ships = [
        Ship.new('carrier', 5),
        Ship.new('battleship', 4),
      ]
      board = Board.new(ships)
      ShipPlacer.place_all(board)
      assert_equal ships.sort, board.grid.flatten.filter {|cell| !cell.ship.nil?}.map(&:ship).uniq.sort
    end

    # it 'distributes ships evenly' do
    #   boards = []
    #   10000.times do
    #     board = Board.new(Game.ships)
    #     ShipPlacer.place_all(board)
    #     boards << board
    #   end
    #   counts = boards.reduce(Hash.new(0)) do |sums, board|
    #     board.cells.each do |position, cell|
    #       # require 'pry-byebug'; binding.pry
    #       if cell.ship
    #           sums[position] +=1
    #       end
    #     end
    #     sums
    #   end
    # end
  end

  describe 'place_ship' do
    it 'places_a single ship' do
      skip
      ship = Ship.new('carrier', 5)
      board = Board.new([ship])
      ShipPlacer.place_ship(ship, board)
      assert_equal [ship], board.grid.flatten.filter {|cell| !cell.ship.nil?}.map(&:ship).uniq.sort
    end

    it 'tries a different direction if the ship placement fails' do
      skip
      ship_1 = Ship.new('carrier', 5)
      ship_2 = Ship.new('battleship', 4)
      board = Board.new([ship_1, ship_2])
      rnd_index_return_values = [0,1,0,0]
      rnd_direction_return_values = [:right, :right, :down]
      ShipPlacer.stub :random_index, ->{ rnd_index_return_values.shift } do
        ShipPlacer.stub :random_direction, ->(exclude=[]) { rnd_direction_return_values.shift } do
          ShipPlacer.place_ship(ship_1, board)
          ShipPlacer.place_ship(ship_2, board)
          assert_equal ["A1", "B1", "C1", "D1"], ship_2.positions
        end
      end
    end

    it 'tries multiple different directions if multiple directions fail' do
      skip
      ship = Ship.new('carrier', 5)
      board = Board.new([ship])
      rnd_index_return_values = [0,0]
      rnd_direction_return_values = [:left, :up, :down]
      ShipPlacer.stub :random_index, ->{ rnd_index_return_values.shift } do
        ShipPlacer.stub :random_direction, ->(exclude=[]) { rnd_direction_return_values.shift } do
          ShipPlacer.place_ship(ship, board)
          assert_equal ["A1", "B1", "C1", "D1", "E1"], ship.positions
        end
      end
    end

    it 'tries a new starting cell if all directions fail' do
      skip
      ship_1 = Ship.new('carrier', 5)
      ship_2 = Ship.new('battleship', 4)
      board = Board.new([ship_1, ship_2])
      rnd_index_return_values = [0,0,0,1,0,6]
      rnd_direction_return_values = [:right, :right, :left, :down, :up, nil, :down]
      ShipPlacer.stub :random_index, ->{ rnd_index_return_values.shift } do
        ShipPlacer.stub :random_direction, ->(exclude=[]) { rnd_direction_return_values.shift } do
          ShipPlacer.place_ship(ship_1, board)
          ShipPlacer.place_ship(ship_2, board)
          assert_equal ["A7", "B7", "C7", "D7"], ship_2.positions
        end
      end
    end

    it 'tries multiple new cells on repeated failures' do
      skip
      ship_1 = Ship.new('carrier', 5)
      ship_2 = Ship.new('battleship', 4)
      board = Board.new([ship_1, ship_2])
      rnd_index_return_values = [0,0,0,1,0,2,0,6]
      rnd_direction_return_values = [
        :right, :right, :left, :down, :up, nil, :right, :left, :down, :up, nil, :down
      ]
      ShipPlacer.stub :random_index, ->{ rnd_index_return_values.shift } do
        ShipPlacer.stub :random_direction, ->(exclude=[]) { rnd_direction_return_values.shift } do
          ShipPlacer.place_ship(ship_1, board)
          ShipPlacer.place_ship(ship_2, board)
          assert_equal ["A7", "B7", "C7", "D7"], ship_2.positions
        end
      end
    end

  end

  describe '.coordinates_for_ship_in_direction' do
    it "selects the appropriate cells to the right" do
      skip
      board = Board.new
      result = ShipPlacer.coordinates_for_ship_in_direction([0,0], :right, 4, board)
      assert_equal %w(A1 A2 A3 A4), result
    end

    it "selects the appropriate cells to the left" do
      skip
      board = Board.new
      result = ShipPlacer.coordinates_for_ship_in_direction([3,0], :left, 4, board)
      assert_equal %w(A1 A2 A3 A4), result
    end

    it "selects the appropriate cells to the south" do
      skip
      board = Board.new
      result = ShipPlacer.coordinates_for_ship_in_direction([0,0], :down, 4, board)
      assert_equal %w(A1 B1 C1 D1), result
    end

    it "selects the appropriate cells to the north" do
      skip
      board = Board.new
      result = ShipPlacer.coordinates_for_ship_in_direction([0,3], :up, 4, board)
      assert_equal %w(A1 B1 C1 D1), result
    end

    it "raises an error if cells are not on the board to the left" do
      skip
      board = Board.new
      assert_raises(ShipPlacementError) { ShipPlacer.coordinates_for_ship_in_direction([0,0], :left, 4, board) }
    end

    it "raises an error if cells are not on the board to the north" do
      skip
      board = Board.new
      assert_raises(ShipPlacementError) { ShipPlacer.coordinates_for_ship_in_direction([0,0], :up, 4, board) }
    end

    it "raises an error if cells are not on the board to the right" do
      skip
      board = Board.new
      assert_raises(ShipPlacementError) { ShipPlacer.coordinates_for_ship_in_direction([9,9], :right, 4, board) }
    end

    it "raises an error if cells are not on the board to the south" do
      skip
      board = Board.new
      assert_raises(ShipPlacementError) { ShipPlacer.coordinates_for_ship_in_direction([9,9], :down, 4, board) }
    end

    it "can place ship up to the edge of the board" do
      skip
      board = Board.new
      assert_equal %w[J6 J7 J8 J9 J10], ShipPlacer.coordinates_for_ship_in_direction([5,9], :right, 5, board)
    end

    it "raises an error if only one cell is off the board" do
      skip
      board = Board.new
      assert_raises(ShipPlacementError) { ShipPlacer.coordinates_for_ship_in_direction([6,9], :right, 5, board) }
    end
  end
end