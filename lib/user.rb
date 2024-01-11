class User
  attr_accessor :name, :board, :ships, :ship_placement_strategy

  def initialize(name: 'Computer', fire_strategy: nil)
    @name = name
    @board = nil
    @ship_placement_strategy = nil
    @fire_strategy = fire_strategy
  end
  
  def lost?
    @board.ships.all? { |ship| ship.sunk? }
  end

  def place_ships
    @ship_placement_strategy.place_all(@board)
  end

  def take_turn(opponent_board)
    @fire_strategy.fire_upon(opponent_board)
  end

end