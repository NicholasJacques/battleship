require './lib/fire_strategies/fire_position_validator.rb'
require './lib/fire_strategies/fire_result.rb'

class ManualFireStrategy
  def initialize(board)
    @board = board
  end

  def fire(position)
    result = nil
    begin
      FirePositionValidator.validate_fire_position(position, @board)
      result = @board.fire(position)
    rescue FirePositionError => error
      result = FireResult.new(position, errors: error.errors)
    end
    return result
  end
end