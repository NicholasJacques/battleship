require './lib/board.rb'

class RandomShipPlacementStrategy
  def self.place_all(board)
    messages = []
    board.ships.each do |ship|
      messages << place_ship(ship, board)
    end
    return [true, messages]

  end

  def self.place_ship(ship, board)
    ship_placed = false
    starting_row = random_index
    starting_column = random_index
    direction = random_direction
    directions_tried = []
    messages = nil
    until ship_placed do
      begin
        positions = coordinates_for_ship_in_direction([starting_column, starting_row], direction, ship.size, board)
        board.place(positions, ship)
        message = "Placed #{ship.name} at #{positions.join(' ')}"
        ship_placed = true
      rescue ShipPlacementError
        directions_tried << direction
        direction = random_direction(directions_tried)
        if direction.nil?
          starting_row = random_index
          starting_column = random_index
          direction = random_direction
        end  
      end
    end
    return message
  end

  def self.coordinates_for_ship_in_direction(starting_cell, direction, ship_size, board)
    starting_column, starting_row = starting_cell
    case direction
    when :up
      raise ShipPlacementError if starting_row-ship_size+1 < 0
      (starting_row-ship_size+1..starting_row).to_a
        .zip(Array.new(ship_size) {starting_column})
        .map {|y, x| board.convert_cell_indexes_to_position(x, y) }
    when :down
      raise ShipPlacementError if starting_row+ship_size-1 > 9
      (starting_row...starting_row+ship_size).to_a
        .zip(Array.new(ship_size) {starting_column})
        .map {|y, x| board.convert_cell_indexes_to_position(x, y)}
    when :left
      raise ShipPlacementError if starting_column-ship_size+1 < 0
      (starting_column-ship_size+1..starting_column).to_a
        .zip(Array.new(ship_size) {starting_row})
        .map {|x, y| board.convert_cell_indexes_to_position(x, y)}
    when :right
      raise ShipPlacementError if starting_column+ship_size-1 > 9
      (starting_column...starting_column+ship_size).to_a
        .zip(Array.new(ship_size) {starting_row})
        .map {|x, y| board.convert_cell_indexes_to_position(x, y)}
    end
  end

  def self.random_index
    (0..9).to_a.sample
  end
  private_class_method :random_index

  def self.random_direction(exclude=[])
    ([:up, :down, :left, :right] - exclude).shuffle.first
  end
  private_class_method :random_direction
end
