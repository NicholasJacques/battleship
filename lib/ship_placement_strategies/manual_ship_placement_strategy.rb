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
end