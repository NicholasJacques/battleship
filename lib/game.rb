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
      name: 'User',
      board: user_board,
      fire_strategy: FireStrategyFactory.create(:manual, ai_board),
    )
    @ai = User.new(
      board: ai_board,
      ship_placement_strategy: RandomShipPlacementStrategy,
    )
    @ai.fire_strategy = FireStrategyFactory.create(:random, @user.board, user: @ai)
  end

  def self.play
    new.play
  end

  def over?
    @user.lost? || @ai.lost?
  end

  def to_s
    "Game: #{@user.name}; #{@ai.name}"
  end
end