class User
  attr_accessor :name, :board, :ships

  def initialize(name='Computer')
    @name = name
    @board = nil
    @ship_placement_strategy = nil
  end
  
  def lost?
    @board.ships.all? { |ship| ship.sunk? }
  end

end