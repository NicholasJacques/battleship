require_relative './ship.rb'
require_relative './user.rb'
require './lib/board.rb'
require './lib/ship_placement_strategies/random_ship_placement_strategy.rb'
require './lib/ship_placement_strategies/manual_ship_placement_strategy.rb'
require './lib/fire_strategies/fire_strategy_factory.rb'
# require './lib/fire_strategies/manual_fire_strategy.rb'
# require './lib/fire_strategies/random_fire_strategy.rb'

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
    winner = play_game
    puts "#{winner.name} won!"

  end

  def welcome
    puts "Welcome to BATTLESHIP \n What is your name?"
  end

  def ask_name
    puts "What is your name?"
    name = gets.chomp
    @user = User.new(name: name)
  end

  def acknowledge_player
    puts "Ok, #{@user.name}, let's go!"
  end

  def setup_boards
    user_board = Board.new(Game.ships)
    ai_board = Board.new(Game.ships)

    @user.fire_strategy = FireStrategyFactory.create(:manual, ai_board)
    @user.board = user_board
    puts @user.board.render

    puts "Do you want to use auto-place your ships? [Y] [N]?"
    input = gets.chomp
    if input.upcase == 'Y'
      @user.ship_placement_strategy = RandomShipPlacementStrategy
    else
      @user.ship_placement_strategy = ManualShipPlacementStrategy
    end
    @user.place_ships

    @ai = User.new
    @ai.fire_strategy = FireStrategyFactory.create(:random, user_board, user: @ai)
    @ai.board = ai_board
    @ai.ship_placement_strategy = RandomShipPlacementStrategy
    @ai.place_ships

    puts "Computer's Board:"
    puts @ai.board.render(show_ships: false)
    puts "Your Board:"
    puts @user.board.render
  end

  def play_game
    game_over = false
    until game_over do
      user_turn
      puts @ai.board.render(show_ships: false)
      return @user if @ai.lost?
      computer_turn
      puts @user.board.render
      return @ai if @user.lost?
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
end