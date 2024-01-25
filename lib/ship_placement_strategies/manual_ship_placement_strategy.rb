class ManualShipPlacementStrategy
  def self.place_ship(ship:, board:, position:)
    begin
      board.place(position, ship)
      return [true, ["Placed #{ship.name} at #{position}"]]
    rescue ShipPlacementError => error
      return [false, error.errors]
    end
  end
end