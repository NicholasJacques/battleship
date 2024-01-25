class FirePositionValidator
  private_class_method :new

  def self.validate_fire_position(position:, board:)
    new(position: position, board: board).validate_fire_position
  end

  def initialize(position:, board:)
    @position = position
    @board = board
    @errors = []
  end

  def validate_fire_position
    validate_cell_exists
    validate_cell_not_already_fired_upon

    raise FirePositionError.new(position, errors: errors) if !errors.empty?
  end

  private
  attr_reader :position, :board, :errors
  
  def validate_cell_not_already_fired_upon
    if board.cells[position] && board.cells[position].hit
      errors << "Cell #{position} has already been fired upon."
    end
  end

  def validate_cell_exists
    if !board.cells[position]
      errors << "Cell #{position} is not on the board."
    end
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