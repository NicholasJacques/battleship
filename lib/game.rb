require './lib/board.rb'
require './lib/user.rb'
require './lib/ship.rb'
require './lib/ship_placement_strategies/random_ship_placement_strategy.rb'
require './lib/fire_strategies/fire_strategy_factory.rb'

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

  attr_reader :user, :ai
  def initialize
    ai_board = Board.new(ships: Game.ships)
    user_board = Board.new(ships: Game.ships)

    @user = User.new(
      name: 'User',
      board: user_board,
      fire_strategy: FireStrategyFactory.create(fire_strategy_name: :manual, board: ai_board),
    )
    # @user = User.new(
    #   name: 'User',
    #   board: user_board,
    # )

    # @user.fire_strategy = FireStrategyFactory.create(fire_strategy_name: :random, board: ai_board, user: @user)
    @ai = User.new(board: ai_board)
  end

  def over?
    user.lost? || ai.lost?
  end

  def winner
    if @user.lost?
      ai
    elsif ai.lost?
      user
    end
  end
end
