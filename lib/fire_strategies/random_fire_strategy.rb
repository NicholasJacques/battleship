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
    result = @board.fire(position)
  end

  def hunt_ships
    position = nil
    if @user.fire_history.any?
      @user.fire_history.reverse.each do |fire_result|
        cell = fire_result.cell
        if cell.hit_or_miss == :hit && !cell.ship.sunk?
          adjacent_cells = @board.adjacent_cells(cell.position)
          adjacent_hits = adjacent_cells.filter {|cell| cell.hit == true && cell.ship && !cell.ship.sunk?}
          if adjacent_hits.any?
            horizontally_adjacent_hits = @board.adjacent_horizontal_cells(cell.position).filter {|cell| cell.hit_or_miss == :hit}.map(&:position)
            vertically_adjacent_hits = @board.adjacent_vertical_cells(cell.position).filter {|cell| cell.hit_or_miss == :hit}.map(&:position)
            
            candidates = []
            if horizontally_adjacent_hits.any?
              horizontally_adjacent_hits << cell.position
              candidates += @board.left_and_right_of_row(horizontally_adjacent_hits)
            end

            if vertically_adjacent_hits.any?
              vertically_adjacent_hits << cell.position
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

  def direction_of_ship(ship)
    @ship_directions[ship.name] if @ship_directions[ship.name]
    if ship.positions[0][0] == ship.positions[1][0]
      @ship_directions[ship.name] = :horizontal
    else
      @ship_directions[ship.name] = :vertical
    end
  end
end