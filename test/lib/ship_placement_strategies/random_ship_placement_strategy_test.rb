require 'minitest/autorun'

require './lib/ship_placement_strategies/random_ship_placement_strategy.rb'
require './lib/board.rb'
require './lib/ship.rb'
require './lib/game.rb'

describe RandomShipPlacementStrategy do
  describe '.place_all' do
    it 'it places all ships' do
      # skip
      ships = [
        Ship.new('carrier', 5),
        Ship.new('battleship', 4),
      ]
      board = Board.new(ships: ships)
      RandomShipPlacementStrategy.place_all(board: board)
      assert_equal ships.sort, board.grid.flatten.filter {|cell| !cell.ship.nil?}.map(&:ship).uniq.sort
    end

    # it 'distributes ships evenly' do
    #   boards = []
    #   10000.times do
    #     board = Board.new(Game.ships)
    #     RandomShipPlacementStrategy.place_all(board)
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
      # skip
      ship = Ship.new('carrier', 5)
      board = Board.new(ships: [ship])
      RandomShipPlacementStrategy.place_ship(ship: ship, board: board)
      assert_equal [ship], board.grid.flatten.filter {|cell| !cell.ship.nil?}.map(&:ship).uniq.sort
    end

    it 'tries a different direction if the ship placement fails' do
      # skip
      ship_1 = Ship.new('carrier', 5)
      ship_2 = Ship.new('battleship', 4)
      board = Board.new(ships: [ship_1, ship_2])
      rnd_index_return_values = [1,0,0,0]
      rnd_direction_return_values = [:right, :right, :down]
      RandomShipPlacementStrategy.stub :random_index, ->{ rnd_index_return_values.shift } do
        RandomShipPlacementStrategy.stub :random_direction, ->(exclude=[]) { rnd_direction_return_values.shift } do
          RandomShipPlacementStrategy.place_ship(ship: ship_1, board: board)
          RandomShipPlacementStrategy.place_ship(ship: ship_2, board: board)
          assert_equal ["A1", "B1", "C1", "D1"], ship_2.positions
        end
      end
    end

    it 'tries multiple different directions if multiple directions fail' do
      # skip
      ship = Ship.new('carrier', 5)
      board = Board.new(ships: [ship])
      rnd_index_return_values = [0,0]
      rnd_direction_return_values = [:left, :up, :down]
      RandomShipPlacementStrategy.stub :random_index, ->{ rnd_index_return_values.shift } do
        RandomShipPlacementStrategy.stub :random_direction, ->(exclude=[]) { rnd_direction_return_values.shift } do
          RandomShipPlacementStrategy.place_ship(ship: ship, board: board)
          assert_equal ["A1", "B1", "C1", "D1", "E1"], ship.positions
        end
      end
    end

    it 'tries a new starting cell if all directions fail' do
      # skip
      ship_1 = Ship.new('carrier', 5)
      ship_2 = Ship.new('battleship', 4)
      board = Board.new(ships: [ship_1, ship_2])
      rnd_index_return_values = [0,0,1,0,6,0]
      rnd_direction_return_values = [:right, :right, :left, :down, :up, nil, :down]
      RandomShipPlacementStrategy.stub :random_index, ->{ rnd_index_return_values.shift } do
        RandomShipPlacementStrategy.stub :random_direction, ->(exclude=[]) { rnd_direction_return_values.shift } do
          RandomShipPlacementStrategy.place_ship(ship: ship_1, board: board)
          RandomShipPlacementStrategy.place_ship(ship: ship_2, board: board)
          assert_equal ["A7", "B7", "C7", "D7"], ship_2.positions
        end
      end
    end

    it 'tries multiple new cells on repeated failures' do
      # skip
      ship_1 = Ship.new('carrier', 5)
      ship_2 = Ship.new('battleship', 4)
      board = Board.new(ships: [ship_1, ship_2])
      rnd_index_return_values = [0,0,1,0,2,0,6,0]
      rnd_direction_return_values = [
        :right, :right, :left, :down, :up, nil, :right, :left, :down, :up, nil, :down
      ]
      RandomShipPlacementStrategy.stub :random_index, ->{ rnd_index_return_values.shift } do
        RandomShipPlacementStrategy.stub :random_direction, ->(exclude=[]) { rnd_direction_return_values.shift } do
          RandomShipPlacementStrategy.place_ship(ship: ship_1, board: board)
          RandomShipPlacementStrategy.place_ship(ship: ship_2, board: board)
          assert_equal ["A7", "B7", "C7", "D7"], ship_2.positions
        end
      end
    end

  end

  describe '.coordinates_for_ship_in_direction' do
    it "selects the appropriate cells to the right" do
      # skip
      board = Board.new
      result = RandomShipPlacementStrategy.send(:coordinates_for_ship_in_direction, starting_cell: [0,0], direction: :right, ship_size: 4, board: board)
      assert_equal %w(A1 A2 A3 A4), result
    end

    it "selects the appropriate cells to the left" do
      # skip
      board = Board.new
      result = RandomShipPlacementStrategy.send(:coordinates_for_ship_in_direction, starting_cell: [3,0], direction: :left, ship_size: 4, board: board)
      assert_equal %w(A1 A2 A3 A4), result
    end

    it "selects the appropriate cells to the south" do
      # skip
      board = Board.new
      result = RandomShipPlacementStrategy.send(:coordinates_for_ship_in_direction, starting_cell: [0,0], direction: :down, ship_size: 4, board: board)
      assert_equal %w(A1 B1 C1 D1), result
    end

    it "selects the appropriate cells to the north" do
      # skip
      board = Board.new
      result = RandomShipPlacementStrategy.send(:coordinates_for_ship_in_direction, starting_cell: [0,3], direction: :up, ship_size: 4, board: board)
      assert_equal %w(A1 B1 C1 D1), result
    end

    it "raises an error if cells are not on the board to the left" do
      # skip
      board = Board.new
      assert_raises(ShipPlacementError) { RandomShipPlacementStrategy.send(:coordinates_for_ship_in_direction, starting_cell: [0,0], direction: :left, ship_size: 4, board: board) }
    end

    it "raises an error if cells are not on the board to the north" do
      # skip
      board = Board.new
      assert_raises(ShipPlacementError) { RandomShipPlacementStrategy.send(:coordinates_for_ship_in_direction, starting_cell: [0,0], direction: :up, ship_size: 4, board: board) }
    end

    it "raises an error if cells are not on the board to the right" do
      # skip
      board = Board.new
      assert_raises(ShipPlacementError) { RandomShipPlacementStrategy.send(:coordinates_for_ship_in_direction, starting_cell: [9,9], direction: :right, ship_size: 4, board: board) }
    end

    it "raises an error if cells are not on the board to the south" do
      # skip
      board = Board.new
      assert_raises(ShipPlacementError) { RandomShipPlacementStrategy.send(:coordinates_for_ship_in_direction, starting_cell: [9,9], direction: :down, ship_size: 4, board: board) }
    end

    it "can place ship up to the edge of the board" do
      # skip
      board = Board.new
      assert_equal %w[J6 J7 J8 J9 J10], RandomShipPlacementStrategy.send(:coordinates_for_ship_in_direction, starting_cell: [5,9], direction: :right, ship_size: 5, board: board)
    end

    it "raises an error if only one cell is off the board" do
      # skip
      board = Board.new
      assert_raises(ShipPlacementError) { RandomShipPlacementStrategy.send(:coordinates_for_ship_in_direction, starting_cell: [6,9], direction: :right, ship_size: 5, board: board) }
    end
  end
end