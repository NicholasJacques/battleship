require 'minitest/autorun'
require './lib/board.rb'
require './lib/ship_placement_strategies/ship_placement_validator.rb'
require './lib/ship.rb'

describe ShipPlacementValidator do
  before do
    @carrier = Ship.new("carrier", 5)
    @battleship = Ship.new("battleship", 4)
    @destroyer = Ship.new("destroyer", 3)
    @submarine = Ship.new("submarine", 3)
    @patrol = Ship.new("patrol boat", 2)
    @ships = [@carrier, @battleship, @destroyer, @submarine, @patrol]
    @board = Board.new(@ships)
  end

  describe "#validate_placement" do
    it "accepts valid ship position" do
      # skip
      @ships.each do |ship|
        assert_nil ShipPlacementValidator.validate_placement(("A1"..).first(ship.size), ship, @board)
      end
    end

    it "rejects when not enough cells are specified" do
      # skip
      @ships.each do |ship|
        number_of_cells = (1...ship.size).to_a.sample
        error = assert_raises(
          ShipPlacementError,
        ) { ShipPlacementValidator.validate_placement(("A1"..).first(number_of_cells), ship, @board) }
        assert_equal ["Ship requires #{ship.size} cells. Only #{number_of_cells} provided."], error.errors
      end
    end

    it "rejects when too many cells are specified" do
      # skip
      @ships.each do |ship|
        number_of_cells = (ship.size+1..9).to_a.sample
        error = assert_raises(
          ShipPlacementError,
        ) { ShipPlacementValidator.validate_placement(("A1"..).first(number_of_cells), ship, @board) }
        assert_equal ["Ship requires #{ship.size} cells. #{number_of_cells} provided."], error.errors
      end
    end

    it "rejects when a cell is already occupied" do
      # skip
      @board.place("a1 a2 a3 a4 a5", @carrier)
      error = assert_raises(ShipPlacementError) { ShipPlacementValidator.validate_placement(%w(A1 B1 C1 D1), @battleship, @board) }
      assert_equal ["Cell A1 is already occupied by your Carrier."], error.errors
    end

    it "rejects when multiple cells are already occupied" do
      # skip
      @board.place("a1 a2 a3 a4 a5", @carrier)
      @board.place("b1 b2 b3 b4", @battleship)
      error = assert_raises(ShipPlacementError) { ShipPlacementValidator.validate_placement(%w(A1 B1 C1), @destroyer, @board) }
      assert_equal ["Cell A1 is already occupied by your Carrier.", "Cell B1 is already occupied by your Battleship."], error.errors
    end

    it "rejects when cell is not on the board" do
      # skip
      error = assert_raises(ShipPlacementError) { ShipPlacementValidator.validate_placement(%w(A0 A1 A2), @destroyer, @board) }

      assert_equal ["Cell A0 is not on the board."], error.errors
    end

    it "rejects when multiple cells are not on the board" do
      # skip
      error = assert_raises(ShipPlacementError) { ShipPlacementValidator.validate_placement(%w(A10 A11 A12), @destroyer, @board) }

      assert_equal ["Cell A11 is not on the board.", "Cell A12 is not on the board."], error.errors
    end

    it "rejects when cells are not in sequential order in a row" do
      # skip
      error = assert_raises(ShipPlacementError) { ShipPlacementValidator.validate_placement(%w(A3 A4 A6), @destroyer, @board) }
      assert_equal ["Ship must be placed vertically or horizontal in sequential cells."], error.errors
    end

    it "rejects when cells are not in sequential order in a column" do
      # skip
      error = assert_raises(ShipPlacementError) { ShipPlacementValidator.validate_placement(%w(A1 C1 D1), @destroyer, @board) }
      assert_equal ["Ship must be placed vertically or horizontal in sequential cells."], error.errors
    end

    it "rejects when cells are placed diagonally" do
      # skip
      error = assert_raises(ShipPlacementError) { ShipPlacementValidator.validate_placement(%w(A1 B2 C3), @destroyer, @board) }
      assert_equal ["Ship must be placed vertically or horizontal in sequential cells."], error.errors
    end

    it "rejects when ship is only 2 cells long" do
      # skip
      [%w(A1 A3), %w(A1 C1), %w(A1 B2)].each do |positions|
        error = assert_raises(ShipPlacementError) { ShipPlacementValidator.validate_placement(positions, @patrol, @board) }
        assert_equal(["Ship must be placed vertically or horizontal in sequential cells."], error.errors,)
      end
    end

    it "rejects when cells are in sequential order but not in a row" do
      # skip
      error = assert_raises(ShipPlacementError) { ShipPlacementValidator.validate_placement(%w(A1 B2 B3 B4 B5), @carrier, @board) }
      assert_equal ["Ship must be placed vertically or horizontal in sequential cells."], error.errors
    end

    it "rejects when cells are in sequential order but not in a column" do
      # skip
      error = assert_raises(ShipPlacementError) { ShipPlacementValidator.validate_placement(%w(A1 B2 C2 D2 E2), @carrier, @board) }
      assert_equal ["Ship must be placed vertically or horizontal in sequential cells."], error.errors
    end

    it "accepts when cells are in a row but given out of order" do
      # skip
      assert_nil ShipPlacementValidator.validate_placement(%w(A2 A1 A3 A5 A4), @carrier, @board)
    end

    it "accepts when cells are in a column but given out of order" do
      # skip
      assert_nil ShipPlacementValidator.validate_placement(%w(B1 A1 C1 E1 D1), @carrier, @board)
    end
  end
end

# TODO Test A1 B2 B3 B4 B5