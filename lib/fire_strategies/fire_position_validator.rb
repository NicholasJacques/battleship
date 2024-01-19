class FirePositionValidator

  def self.validate_fire_position(position, board)
    errors = []

    if !board.cells[position]
      errors << "Cell #{position} is not on the board."
    end

    if board.cells[position] && board.cells[position].hit
      errors << "Cell #{position} has already been fired upon."
    end

    raise FirePositionError.new(position, errors: errors) if !errors.empty?
  end
end

class FirePositionError < StandardError
  attr_reader :errors

  def initialize(position, errors: [])
    msg = "Error firing at #{position}."
    @errors = errors
    super(msg)
  end
end