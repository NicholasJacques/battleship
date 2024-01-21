require './lib/cell.rb'
require './lib/ship_placement_strategies/ship_placement_validator.rb'
require './lib/fire_strategies/fire_result.rb'

class Board
  attr_reader :ships, :cells, :grid

  ROWS = ('A'..'J')
  COLUMNS = (1..10)

  def initialize(ships=[])
    @ships = ships
    @cells = {}
    @grid = []
    ROWS.each_with_index do |row, i|
      @grid << []
      COLUMNS.each do |column|
        position = row + column.to_s
        cell = Cell.new(position)
        @cells[position] = cell
        @grid[i] << cell
      end
    end
  end

  def place(positions, ship)
    if positions.is_a?(String)
      positions = positions.upcase.split
    end
    ShipPlacementValidator.validate_placement(positions, ship, self)
    positions.each {|position| cells[position].ship = ship }
    ship.positions = positions
  end

  def fire(position)
    result = FireResult.new(position, cell: cells[position])
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

  # def get_cell(position)
  #   @grid[y_coordinate(position)][x_coordinate(position)]
  # end

  def adjacent_cells(position)
    raise ArgumentError.new("Invalid position: #{position}") unless cells[position]

    x, y = coordinates(position)
    # north = convert_cell_indexes_to_position(x, y-1)
    # south = convert_cell_indexes_to_position(x, y+1)
    # east = convert_cell_indexes_to_position(x-1, y)
    # west = convert_cell_indexes_to_position(x+1, y)

    [
      convert_cell_indexes_to_position(x, y-1), #north
      convert_cell_indexes_to_position(x, y+1), #south
      convert_cell_indexes_to_position(x-1, y), #east
      convert_cell_indexes_to_position(x+1, y), #west
    ].map {|position| cells[position] }.compact
  end

  def adjacent_horizontal_cells(position)
    raise ArgumentError.new("Invalid position: #{position}") unless cells[position]

    x, y = coordinates(position)
    [
      convert_cell_indexes_to_position(x-1, y), #east
      convert_cell_indexes_to_position(x+1, y), #west
    ].map{|position| cells[position] }.compact
  end

  def adjacent_vertical_cells(position)
    x, y = coordinates(position)
    [
      convert_cell_indexes_to_position(x, y-1), #north
      convert_cell_indexes_to_position(x, y+1), #south
    ].map{|position| cells[position] }.compact
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
    cells[convert_cell_indexes_to_position(x+1, y)]
  end

  def west_of_cell(cell)
    x, y = coordinates(cell.position)
    cells[convert_cell_indexes_to_position(x-1, y)]
  end

  def north_and_south_of_column(list_of_cells)
    top = list_of_cells.min_by {|cell| y_coordinate(cell.position) }
    bottom = list_of_cells.max_by {|cell| y_coordinate(cell.position) }
    [north_of_cell(top), south_of_cell(bottom)].compact
  end

  def east_and_west_of_row(list_of_cells)
    start = list_of_cells.min_by {|cell| x_coordinate(cell.position) }
    endd = list_of_cells.max_by {|cell| x_coordinate(cell.position) }
    [west_of_cell(start), east_of_cell(endd)].compact
  end

  # def left_and_right_of_row(positions)
  #   start = positions.min_by {|position| x_coordinate(position) }
  #   endd = positions.max_by {|position| x_coordinate(position) }
  #   left = convert_cell_indexes_to_position(x_coordinate(start)-1, y_coordinate(start))
  #   right = convert_cell_indexes_to_position(x_coordinate(endd)+1, y_coordinate(endd))
  #   [left, right].map {|position| cells[position] }.compact
  # end

  # def valid_fire_position?(position)
  #   cells[position] && !cells[position].is_hit?
  # end
  
  def coordinates(position)
    [x_coordinate(position), y_coordinate(position)]
  end

  def convert_cell_indexes_to_position(x, y)
    [(y+65).chr, x+1].join
  end

  def x_coordinate(position)
    position[1..].to_i - 1
  end

  def y_coordinate(position)
    position[0].upcase.bytes[0] - 65
  end

    # not used in game logic but useful for printing out the board
    def render(show_ships: true)
      "  " + (1..10).to_a.join(' ') + "\n" + @grid.zip(('A'..'J').to_a).map { |row, row_name| row_name + ' ' + row.map {|cell| cell.render(show_ships: show_ships)}.join(' ') }.join("\n")
    end
end
