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
        validator = ShipPlacementValidator.new(("A1"..).first(ship.size), ship, @board)
        assert_nil validator.validate_placement
      end
    end

    it "rejects when not enough cells are specified" do
      # skip
      @ships.each do |ship|
        number_of_cells = (1...ship.size).to_a.sample
        validator = ShipPlacementValidator.new(("A1"..).first(number_of_cells), ship, @board)
        error = assert_raises(
          ShipPlacementError,
        ) { validator.validate_placement }
        assert_equal ["Ship requires #{ship.size} cells. Only #{number_of_cells} provided."], error.errors
      end
    end

    it "rejects when too many cells are specified" do
      # skip
      @ships.each do |ship|
        number_of_cells = (ship.size+1..9).to_a.sample
        validator = ShipPlacementValidator.new(("A1"..).first(number_of_cells), ship, @board)
        error = assert_raises(
          ShipPlacementError,
        ) { validator.validate_placement }
        assert_equal ["Ship requires #{ship.size} cells. #{number_of_cells} provided."], error.errors
      end
    end

    it "rejects when a cell is already occupied" do
      # skip
      @board.place("a1 a2 a3 a4 a5", @carrier)
      validator = ShipPlacementValidator.new(%w(A1 B1 C1 D1), @battleship, @board)
      error = assert_raises(ShipPlacementError) { validator.validate_placement }
      assert_equal ["Cell A1 is already occupied by your Carrier."], error.errors
    end

    it "rejects when multiple cells are already occupied" do
      # skip
      @board.place("a1 a2 a3 a4 a5", @carrier)
      @board.place("b1 b2 b3 b4", @battleship)
      validator = ShipPlacementValidator.new(%w(A1 B1 C1), @destroyer, @board)
      error = assert_raises(ShipPlacementError) { validator.validate_placement }
      assert_equal ["Cell A1 is already occupied by your Carrier.", "Cell B1 is already occupied by your Battleship."], error.errors
    end

    it "rejects when cell is not on the board" do
      # skip
      validator = ShipPlacementValidator.new(%w(A0 A1 A2), @destroyer, @board)
      error = assert_raises(ShipPlacementError) { validator.validate_placement }

      assert_equal ["Cell A0 is not on the board."], error.errors
    end

    it "rejects when multiple cells are not on the board" do
      # skip
      validator = ShipPlacementValidator.new(%w(A10 A11 A12), @destroyer, @board)
      error = assert_raises(ShipPlacementError) { validator.validate_placement }

      assert_equal ["Cell A11 is not on the board.", "Cell A12 is not on the board."], error.errors
    end

    it "rejects when cells are not in sequential order in a row" do
      # skip
      validator = ShipPlacementValidator.new(%w(A3 A4 A6), @destroyer, @board)
      error = assert_raises(ShipPlacementError) { validator.validate_placement }
      assert_equal ["Ship must be placed vertically or horizontal in sequential cells."], error.errors
    end

    it "rejects when cells are not in sequential order in a column" do
      # skip
      validator = ShipPlacementValidator.new(%w(A1 C1 D1), @destroyer, @board)
      error = assert_raises(ShipPlacementError) { validator.validate_placement }
      assert_equal ["Ship must be placed vertically or horizontal in sequential cells."], error.errors
    end

    it "rejects when cells are placed diagonally" do
      # skip
      validator = ShipPlacementValidator.new(%w(A1 B2 C3), @destroyer, @board)
      error = assert_raises(ShipPlacementError) { validator.validate_placement }
      assert_equal ["Ship must be placed vertically or horizontal in sequential cells."], error.errors
    end

    it "rejects when ship is only 2 cells long" do
      # skip
      [%w(A1 A3), %w(A1 C1), %w(A1 B2)].each do |positions|
        validator = ShipPlacementValidator.new(positions, @patrol, @board)
        error = assert_raises(ShipPlacementError) { validator.validate_placement }
        assert_equal(["Ship must be placed vertically or horizontal in sequential cells."], error.errors,)
      end
    end
  end
end