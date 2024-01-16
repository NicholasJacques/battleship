class User
  attr_accessor :name,
                :board, 
                :ships,
                :ship_placement_strategy,
                :fire_strategy,
                :fire_history

  def initialize(name: 'Computer', board: nil, fire_strategy: nil, ship_placement_strategy: nil)
    @name = name
    @board = board
    @ship_placement_strategy = ship_placement_strategy
    @fire_strategy = fire_strategy
    @fire_history = []
  end
  
  def lost?
    @board.ships.all? { |ship| ship.sunk? }
  end

  def place_ships
    @ship_placement_strategy.place_all(@board)
  end

  def place_ship(ship, positions)
    @ship_placement_strategy.place_all(@board)
  end

  def take_turn(opponent_board)
    @fire_history << @fire_strategy.fire
  end

  def fire(position=nil)
    @fire_history << @fire_strategy.fire(position)
  end

end