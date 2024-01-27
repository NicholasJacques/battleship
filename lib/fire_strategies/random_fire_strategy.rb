class RandomFireStrategy
  attr_reader :board, :user

  def initialize(board:, user:)
    # TODO: @user is unnecessary dependency, should just be fire history
    # TODO: fire history could belong to board?
    @board = board
    @user = user
  end

  def fire(position=nil)
    if user.fire_history.any?
      position = hunt_ships
    end

    if position.nil?
      position = board.cells.filter {|k, v| v.hit == false}.keys.sample
    end

    board.fire(position)
  end

  private

  def hunt_ships
    user.fire_history.reverse.each do |fire_result|
      cell = fire_result.cell
      if pursue_ship?(fire_result)
        horizontally_adjacent_hits = find_horizontally_adjacent_hits(cell)
        vertically_adjacent_hits = find_vertically_adjacent_hits(cell)
        if !horizontally_adjacent_hits.any? && !vertically_adjacent_hits.any?
          return board.adjacent_cells(cell).filter {|cell| cell.hit == false}.sample.position
        else
          candidates = []
          if horizontally_adjacent_hits.any?
            horizontally_adjacent_hits << cell
            candidates += board.east_and_west_of_row(horizontally_adjacent_hits)
          end

          if vertically_adjacent_hits.any?
            vertically_adjacent_hits << cell
            candidates += board.north_and_south_of_column(vertically_adjacent_hits)
          end
          # if candidates.filter {|cell| cell.hit == false}.empty?
          #   Curses.close_screen
          #   require 'pry-byebug'; binding.pry
          # end

          return candidates.filter {|cell| cell.hit == false}.sample.position
        end
      end
    end
    nil
  end

  def pursue_ship?(fire_result)
    fire_result.is_hit && !fire_result.ship.sunk?
  end

  def find_vertically_adjacent_hits(cell)
    adjacent_hits = []

    current_cell = cell
    loop do
      cell_to_the_north = board.north_of_cell(current_cell)
      break if cell_to_the_north.nil? || !cell_to_the_north.is_ship_hit? || cell_to_the_north.ship.sunk?
      adjacent_hits << cell_to_the_north
      current_cell = cell_to_the_north
    end

    current_cell = cell
    loop do
      cell_to_the_south = board.south_of_cell(current_cell)
      break if cell_to_the_south.nil? || !cell_to_the_south.is_ship_hit? || cell_to_the_south.ship.sunk?
      adjacent_hits << cell_to_the_south
      current_cell = cell_to_the_south
    end

    adjacent_hits
  end

  def find_horizontally_adjacent_hits(cell)
    adjacent_hits = []
    current_cell = cell
    loop do
      cell_to_the_east = board.east_of_cell(current_cell)
      break if cell_to_the_east.nil? || !cell_to_the_east.is_ship_hit? || cell_to_the_east.ship.sunk?
      adjacent_hits << cell_to_the_east
      current_cell = cell_to_the_east
    end

    current_cell = cell
    loop do
      cell_to_the_west = board.west_of_cell(current_cell)
      break if cell_to_the_west.nil? || !cell_to_the_west.is_ship_hit? || cell_to_the_west.ship.sunk?
      adjacent_hits << cell_to_the_west
      current_cell = cell_to_the_west
    end

    adjacent_hits
  end

  # def direction_of_ship(ship)
  #   @ship_directions[ship.name] if @ship_directions[ship.name]
  #   if ship.positions[0][0] == ship.positions[1][0]
  #     @ship_directions[ship.name] = :horizontal
  #   else
  #     @ship_directions[ship.name] = :vertical
  #   end
  # end
end