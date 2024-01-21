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
    board.ships.all? { |ship| ship.sunk? }
  end

  def fire(position=nil)
    result = fire_strategy.fire(position)
    if result.errors.empty?
      fire_history << result
    end
    result
  end

end