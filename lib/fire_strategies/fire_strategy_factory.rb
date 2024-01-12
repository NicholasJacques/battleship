require './lib/fire_strategies/manual_fire_strategy.rb'
require './lib/fire_strategies/random_fire_strategy.rb'

module FireStrategyFactory
  def self.create(fire_strategy_name, board, user: nil)
    case fire_strategy_name
    when :manual
      ManualFireStrategy.new(board)
    when :random
      RandomFireStrategy.new(board, user)
    # when :cheat
      # CheatFireStrategy
    end
  end
    
end