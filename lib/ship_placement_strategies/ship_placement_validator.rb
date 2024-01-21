class ShipPlacementValidator

  def self.validate_placement(positions, ship, board)
    new(positions, ship, board).validate_placement
  end

  def initialize(positions, ship, board)
    @positions = positions
    @ship = ship
    @board = board
    @errors = []
  end

  def validate_placement
    validate_ship_size
    validate_cells_are_in_order
    validate_each_cell
    raise ShipPlacementError.new(errors: errors) if errors.any?
  end

  private
  attr_accessor :errors
  attr_reader :positions, :ship, :board

  def validate_ship_size
    if positions.length < ship.size
      errors << "Ship requires #{ship.size} cells. Only #{positions.length} provided."
    elsif positions.length > ship.size
      errors <<  "Ship requires #{ship.size} cells. #{positions.length} provided."
    end
  end

  def validate_cells_are_in_order
    return if positions.size <= 1
    coordinates = positions.map { |position| board.coordinates(position) }.sort
    starting_x = coordinates[0][0]
    starting_y = coordinates[0][1]
    is_horizontal = (starting_x...starting_x+positions.size).to_a.product([starting_y]) == coordinates
    is_vertical = [starting_x].product((starting_y...starting_y+positions.size).to_a) == coordinates

    if (!is_vertical && !is_horizontal) || (is_horizontal && is_vertical)
      errors << "Ship must be placed vertically or horizontal in sequential cells."
    end

  end

  def validate_each_cell
    positions.each do |position|
      validate_position_on_board(position)
      validate_cell_is_not_occupied(position)
    end
  end

  def validate_position_on_board(position)
    if board.cells[position].nil?
      errors << "Cell #{position} is not on the board."
    end
  end

  def validate_cell_is_not_occupied(position)
    cell = board.cells[position]
    if cell && cell.ship
      errors << "Cell #{position} is already occupied by your #{cell.ship.name.capitalize}."
    end
  end
end

class ShipPlacementError < StandardError
  attr_reader :errors

  def initialize(msg: "Error placing ship.", errors: [])
    @errors = errors
    super(msg)
  end
end