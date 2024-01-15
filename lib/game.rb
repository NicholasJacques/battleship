require 'io/console'

require_relative './ship.rb'
require_relative './user.rb'
require './lib/board.rb'
require './lib/ship_placement_strategies/random_ship_placement_strategy.rb'
require './lib/ship_placement_strategies/manual_ship_placement_strategy.rb'
require './lib/fire_strategies/fire_strategy_factory.rb'
require './lib/render.rb'
require './lib/ui/new_renderer.rb'
require 'curses'

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
    @renderer = Render.new(self)
    @user = nil
    @ai = nil
    @new_renderer = NewRenderer.new
  end

  def self.play
    new.play
  end

  def play
    splash_screen
    resize_window_prompt
    welcome
    setup_boards
    # winner = play_game
    # puts "#{winner.name} won!"

  end

  def splash_screen
    @new_renderer.splash_screen
    @new_renderer.window.getch
  end

  def resize_window_prompt
    @new_renderer.resize_window_prompt
  end

  def welcome
    @new_renderer.ask_name
    name = @new_renderer.window.getstr
    @user = User.new(name: name)
  end

  def setup_boards
    user_board = Board.new(Game.ships)
    ai_board = Board.new(Game.ships)

    @user.fire_strategy = FireStrategyFactory.create(:manual, ai_board)
    @user.board = user_board

    @new_renderer.display_user_board
  end

  # def setup_boards
  #   user_board = Board.new(Game.ships)
  #   ai_board = Board.new(Game.ships)

  #   @user.fire_strategy = FireStrategyFactory.create(:manual, ai_board)
  #   @user.board = user_board
  #   @renderer.render_splash(footer: "Would you like to place your own ships? (Y/N)")
  #   input = gets.chomp
  #   if input.upcase == 'Y'
  #     @user.ship_placement_strategy = ManualShipPlacementStrategy
  #   else
  #     @user.ship_placement_strategy = RandomShipPlacementStrategy
  #     @user.place_ships
  #   end

  #   @ai = User.new
  #   @ai.fire_strategy = FireStrategyFactory.create(:random, user_board, user: @ai)
  #   @ai.board = ai_board
  #   @ai.ship_placement_strategy = RandomShipPlacementStrategy
  #   @ai.place_ships
  #   @renderer.render_boards(@user.board, @ai.board, show_opponent_ships: false)
  # end

  def play_game
    game_over = false
    until game_over do
      user_turn
      @renderer.render_boards(@user.board, @ai.board, show_opponent_ships: false)
      return @user if @ai.lost?
      computer_turn
      puts @renderer.render_boards(@user.board, @ai.board, show_opponent_ships: false)
      return @ai if @user.lost?
    end
  end

  def user_turn
    @user.take_turn(@ai.board)
  end

  def computer_turn
    @ai.take_turn(@user.board)
  end
end