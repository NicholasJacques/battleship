require './lib/cell.rb'
require './lib/ship_placement_strategies/ship_placement_validator.rb'
require './lib/fire_strategies/fire_result.rb'

class Board
  attr_reader :ships, :cells, :grid

  def initialize(ships: [])
    @ships = ships
    @cells = {}
    @grid = build_board
  end

  def place(positions, ship)
    if positions.is_a?(String)
      positions = positions.upcase.split
    end
    ShipPlacementValidator.validate_placement(positions: positions, ship: ship, board: self)
    positions.each {|position| cells[position].ship = ship }
    ship.positions = positions
  end

  def fire(position)
    result = FireResult.new(position: position, cell: cells[position])
    cells[position].hit = true
    if cells[position].ship
      cells[position].ship.hit
      result.is_hit = true
      result.ship = cells[position].ship
      result.is_sunk = cells[position].ship.sunk?
    else
      result.is_hit = false
      result.is_sunk = false
    end
    result
  end

  def adjacent_cells(cell)
    raise ArgumentError.new("Invalid position: #{cell.position}") unless cells[cell.position]
    [
      north_of_cell(cell),
      south_of_cell(cell),
      east_of_cell(cell),
      west_of_cell(cell),
    ].compact
  end

  def north_of_cell(cell)
    x, y = coordinates(cell.position)
    cells[convert_cell_indexes_to_position(x, y-1)]
  end

  def south_of_cell(cell)
    x, y = coordinates(cell.position)
    cells[convert_cell_indexes_to_position(x, y+1)]
  end

  def east_of_cell(cell)
    x, y = coordinates(cell.position)
    cells[convert_cell_indexes_to_position(x-1, y)]
  end

  def west_of_cell(cell)
    x, y = coordinates(cell.position)
    cells[convert_cell_indexes_to_position(x+1, y)]
  end

  def north_and_south_of_column(list_of_cells)

    top = list_of_cells.min_by {|cell| y_coordinate(cell.position) }
    bottom = list_of_cells.max_by {|cell| y_coordinate(cell.position) }
    [north_of_cell(top), south_of_cell(bottom)].compact
  end

  def east_and_west_of_row(list_of_cells)
    start = list_of_cells.min_by {|cell| x_coordinate(cell.position) }
    endd = list_of_cells.max_by {|cell| x_coordinate(cell.position) }
    [east_of_cell(start), west_of_cell(endd)].compact
  end
  
  def coordinates(position)
    [x_coordinate(position), y_coordinate(position)]
  end

  def convert_cell_indexes_to_position(x, y)
    [(y+65).chr, x+1].join
  end

  # not used in game logic but useful for printing out the board
  def render(show_ships: true)
    "  " + (1..10).to_a.join(' ') + "\n" + @grid.zip(('A'..'J').to_a).map { |row, row_name| row_name + ' ' + row.map {|cell| cell.render(show_ships: show_ships)}.join(' ') }.join("\n")
  end

  private

  ROWS = ('A'..'J')
  COLUMNS = (1..10)

  def build_board
    result = []

    ROWS.each_with_index do |row, i|
      result << []
      COLUMNS.each do |column|
        position = row + column.to_s
        cell = Cell.new(position)
        @cells[position] = cell
        result[i] << cell
      end
    end

    result
  end

  def x_coordinate(position)
    position[1..].to_i - 1
  end

  def y_coordinate(position)
    position[0].upcase.bytes[0] - 65
  end

end
