class ManualShipPlacementStrategy
  def self.place_ship(ship, board, position)
    begin
      board.place(position, ship)
      return [true, ["Placed #{ship.name}"]]
    rescue ShipPlacementError => error
      require 'pry-byebug'; binding.pry
      return [false, error.errors]
    end
  end
end