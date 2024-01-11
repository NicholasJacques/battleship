class ShipPlacementValidator
  attr_reader :errors

  def initialize(positions, ship, board)
    @positions = positions
    @ship = ship
    @board = board
    @errors = []
  end

  def has_errors?
    !@errors.empty?
  end

  def validate_placement
    validate_ship_size
    validate_cells_are_in_order
    validate_each_cell
    raise ShipPlacementError.new(errors: errors) if has_errors?
  end

  def validate_ship_size
    if @positions.length < @ship.size
      @errors << "Ship requires #{@ship.size} cells. Only #{@positions.length} provided."
    elsif @positions.length > @ship.size
      @errors <<  "Ship requires #{@ship.size} cells. #{@positions.length} provided."
    end
  end

  def validate_cells_are_in_order
    return if @positions.size <= 1
    coordinates = @positions.map { |position| @board.coordinates(position) }
    starting_x = coordinates[0][0]
    starting_y = coordinates[0][1]

    is_horizontal = (starting_x...starting_x+@positions.size).to_a == coordinates.map {|coordinate| coordinate[0] }
    is_vertical = (starting_y...starting_y+@positions.size).to_a == coordinates.map {|coordinate| coordinate[1] }

    if (!is_vertical && !is_horizontal) || (is_horizontal && is_vertical)
      @errors << "Ship must be placed vertically or horizontal in sequential cells."
    end

  end

  def validate_each_cell
    @positions.each do |position|
      validate_position_on_board(position)
      validate_cell_is_not_occupied(position)
    end
  end

  def validate_position_on_board(position)
    if @board.cells[position].nil?
      @errors << "Cell #{position} is not on the board."
    end
  end

  def validate_cell_is_not_occupied(position)
    cell = @board.cells[position]
    if cell && cell.ship
      errors << "Cell #{position} is already occupied by your #{cell.ship.name.capitalize}."
    end
  end
end