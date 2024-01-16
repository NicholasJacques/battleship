require 'io/console'

require_relative './ship.rb'
require_relative './user.rb'
require './lib/board.rb'
require './lib/ship_placement_strategies/random_ship_placement_strategy.rb'
require './lib/ship_placement_strategies/manual_ship_placement_strategy.rb'
require './lib/fire_strategies/fire_strategy_factory.rb'
require './lib/render.rb'
require './lib/ui/ui.rb'
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

  attr_reader :user, :ai, :current_prompt

  def initialize
    ai_board = Board.new(Game.ships)
    user_board = Board.new(Game.ships)

    @user = User.new(
      board: user_board,
      fire_strategy: FireStrategyFactory.create(:manual, ai_board),
    )
    @ai = User.new(
      board: Board.new(Game.ships),
      fire_strategy: FireStrategyFactory.create(:random, user_board),
      ship_placement_strategy: RandomShipPlacementStrategy,
    )
  end

  def self.play
    new.play
  end

  def setup_boards
    user_board = Board.new(Game.ships)
    ai_board = Board.new(Game.ships)
    @user.fire_strategy = FireStrategyFactory.create(:manual, ai_board)
    @user.board = user_board
    @ai.board = ai_board
    @ui.play_game
    @current_prompt = "Would you like to place your own ships? (Y/N)"
    @ui.render
    manual_ship_placement = @ui.prompt

    if manual_ship_placement == 'Y'
      @user.ship_placement_strategy = ManualShipPlacementStrategy
    else
      @user.ship_placement_strategy = RandomShipPlacementStrategy
    end
    @user.place_ships
    @ui.render

    sleep(100)
  end

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

  def over?
    @user.lost? || @ai.lost?
  end
end