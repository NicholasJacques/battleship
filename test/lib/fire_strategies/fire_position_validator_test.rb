require './lib/fire_strategies/fire_position_validator.rb'
require './lib/board.rb'

describe FirePositionValidator do
  describe '.validate_fire_position' do
    it "accepts a valid position" do
      assert_nil FirePositionValidator.validate_fire_position("A1", Board.new)
    end

    it "rejects a position that is not on the board" do
      error = assert_raises(FirePositionError) { FirePositionValidator.validate_fire_position("A11", Board.new) }
      assert_equal ["Cell A11 is not on the board."], error.errors
    end

    it "rejects a position that has already been fired upon" do
      board = Board.new
      board.fire("A1")

      error = assert_raises(FirePositionError) { FirePositionValidator.validate_fire_position("A1", board) }
      assert_equal ["Cell A1 has already been fired upon."], error.errors
    end
  end
end