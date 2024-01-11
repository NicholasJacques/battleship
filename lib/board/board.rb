require_relative './../cell.rb'
require_relative './ship_placement_validator.rb'

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

  def to_s
    "  " + (1..10).to_a.join(' ') + "\n" + @grid.zip(('A'..'J').to_a).map { |row, row_name| row_name + ' ' + row.join(' ') }.join("\n")
  end

  def render(show_ships: true)
    "  " + (1..10).to_a.join(' ') + "\n" + @grid.zip(('A'..'J').to_a).map { |row, row_name| row_name + ' ' + row.map {|cell| cell.render(show_ships: show_ships)}.join(' ') }.join("\n")
  end

  def place(positions, ship)
    if positions.is_a?(String)
      positions = positions.upcase.split
    end
    validator = ShipPlacementValidator.new(positions, ship, self)
    validator.validate_placement

    positions.each {|position| @cells[position].ship = ship }
    ship.positions = positions
  end

  def fire(position)
    cells[position].hit = true
    if cells[position].ship
      cells[position].ship.hit
    end
  end

  # def get_cell(position)
  #   @grid[y_coordinate(position)][x_coordinate(position)]
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
end

class ShipPlacementError < StandardError
  attr_reader :errors

  def initialize(msg: "Error placing ship.", errors: [])
    @errors = errors
    super(msg)
  end
end
