class ManualShipPlacementStrategy
  def self.place_all(board)
    board.ships.each do |ship|
      place_ship(ship, board)
    end
  end

  def self.place_ship(ship, board, position)
    begin
      board.place(position, ship)
    rescue ShipPlacementError => error
      return false
    end
    true
  end

  # def self.place_ship(ship, board)
  #   ship_placed = false
  #   until ship_placed do
  #     puts "\nPlace your #{ship.name.capitalize} (length: #{ship.size})"
  #     position = gets.chomp
  #     begin
  #       board.place(position, ship)
  #     rescue ShipPlacementError => error
  #       puts error.errors
  #       puts "Try again"
  #       next
  #     end
  #     ship_placed = true
  #   end
  # end
end