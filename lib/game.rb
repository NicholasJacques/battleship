require_relative './board/board.rb'
require_relative './ship.rb'
require_relative './user.rb'
require './lib/ship_placement_strategies/random_ship_placement_strategy.rb'
require './lib/ship_placement_strategies/manual_ship_placement_strategy.rb'
require './lib/fire_strategies/manual_fire_strategy.rb'
require './lib/fire_strategies/random_fire_strategy.rb'

class Game
  class << self
    def ships
      [
        Ship.new('carrier', 5),
        Ship.new('battleship', 4),
        Ship.new('destroyer', 3),
        Ship.new('submarine', 3),
        Ship.new('patrol boat', 2),
      ]
    end
  end

  def initialize
    @user = nil
    @ai = nil
  end

  def self.play
    new.play
  end

  def play
    welcome
    ask_name
    acknowledge_player
    setup_boards
    play_game
  end

  def welcome
    puts "Welcome to BATTLESHIP \n What is your name?"
  end

  def ask_name
    puts "What is your name?"
    name = gets.chomp
    @user = User.new(name: name, fire_strategy: ManualFireStrategy)
  end

  def acknowledge_player
    puts "Ok, #{@user.name}, let's go!"
  end

  def setup_boards
    @user.board = Board.new(Game.ships)
    puts @user.board.render

    puts "Do you want to use auto-place your ships? [Y] [N]?"
    input = gets.chomp
    if input.upcase == 'Y'
      @user.ship_placement_strategy = RandomShipPlacementStrategy
    else
      @user.ship_placement_strategy = ManualShipPlacementStrategy
    end
    @user.place_ships

    @ai = User.new(fire_strategy: RandomFireStrategy)
    @ai.board = Board.new(Game.ships)
    @ai.ship_placement_strategy = RandomShipPlacementStrategy
    RandomShipPlacementStrategy.place_all(@ai.board)

    puts "Computer's Board:"
    puts @ai.board.render(show_ships: false)
    puts "Your Board:"
    puts @user.board.render
    game_loop
  end

  def game_loop
    game_over = false
    until game_over do
      user_turn
      computer_turn
      puts @ai.board.render(show_ships: false)
      puts @user.board.render
      game_over = is_game_over?
    end
  end

  def user_turn
    puts "Your turn."
    @user.take_turn(@ai.board)
  end

  def computer_turn
    puts "Computer's turn:"
    @ai.take_turn(@user.board)
  end

  def is_game_over?
    @user.lost? || @ai.lost?
  end
end