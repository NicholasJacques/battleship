class RandomFireStrategy
  def initialize(board, user)
    @board = board
    @user = user
  end

  def fire(position=nil)
    position = hunt_ships

    if position.nil?
      position = @board.cells.filter {|k, v| v.hit == false}.keys.sample
    end
    @board.fire(position)
  end

  def hunt_ships
    position = nil
    if @user.fire_history.any?
      @user.fire_history.reverse.each do |fire_result|
        cell = fire_result.cell
        if fire_result.is_hit && !fire_result.ship.sunk?
          adjacent_cells = @board.adjacent_cells(cell.position)
          adjacent_hits = adjacent_cells.filter {|cell| cell.hit == true && cell.ship && !cell.ship.sunk?}
          if adjacent_hits.any?
            horizontally_adjacent_hits = find_horizontally_adjacent_hits(cell)
            vertically_adjacent_hits = find_vertically_adjacent_hits(cell)

            candidates = []
            if horizontally_adjacent_hits.any?
              horizontally_adjacent_hits << cell
              candidates += @board.east_and_west_of_row(horizontally_adjacent_hits)
            end

            if vertically_adjacent_hits.any?
              vertically_adjacent_hits << cell
              candidates += @board.north_and_south_of_column(vertically_adjacent_hits)
            end
            position = candidates.filter {|cell| cell.hit == false}.sample.position
            break
          else
            position = @board.adjacent_cells(cell.position).filter {|cell| cell.hit == false}.sample.position
            break
          end
        end
      end
    end
    return position
  end

  def find_vertically_adjacent_hits(cell)
    adjacent_hits = []

    current_cell = cell
    loop do
      cell_to_the_north = @board.north_of_cell(current_cell)
      break if cell_to_the_north.nil? || (!cell_to_the_north.is_hit? && cell_to_the_north.ship)
      adjacent_hits << cell_to_the_north
      current_cell = cell_to_the_north
    end

    current_cell = cell
    loop do
      cell_to_the_south = @board.south_of_cell(current_cell)
      break if cell_to_the_south.nil? || (!cell_to_the_south.is_hit? && cell_to_the_south.ship)
      adjacent_hits << cell_to_the_south
      current_cell = cell_to_the_south
    end

    adjacent_hits
  end

  def find_horizontally_adjacent_hits(cell)
    adjacent_hits = []
    current_cell = cell
    loop do
      cell_to_the_east = @board.east_of_cell(current_cell)
      break if cell_to_the_east.nil? || (!cell_to_the_east.is_hit? && cell_to_the_east.ship)
      adjacent_hits << cell_to_the_east
      current_cell = cell_to_the_east
    end

    current_cell = cell
    loop do
      cell_to_the_west = @board.west_of_cell(current_cell)
      break if cell_to_the_west.nil? || (!cell_to_the_west.is_hit? && cell_to_the_west.ship )
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