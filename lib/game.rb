require 'io/console'

require_relative './ship.rb'
require_relative './user.rb'
require './lib/board.rb'
require './lib/ship_placement_strategies/random_ship_placement_strategy.rb'
require './lib/ship_placement_strategies/manual_ship_placement_strategy.rb'
require './lib/fire_strategies/fire_strategy_factory.rb'
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

  attr_reader :user, :ai, :current_action, :messages
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

    @current_action = nil
    @ships_to_place = nil
    # @messages = 30.times.map {|i| "This is message #{i}" }
    @messages = []
  end

  def over?
    @user.lost? || @ai.lost?
  end


  def get_prompt
    actions[current_action][:prompt]
  end

  def process_input(input)
    self.send(actions[current_action][:handler], input)
  end

  ## States

  def actions
    {
      place_ships_decision: {
        prompt: "Would you like to place your own ships? (Y/N)",
        handler: :place_ships_decision_handler,
      },
      manually_place_ships: {
        prompt: place_ships_prompt,
        handler: :manually_place_ships_handler,
      },
      take_turn: {
        prompt: "Select the coordinates to fire at:",
      },
    }
  end

  def setup
    @current_action = :place_ships_decision
    @ships_to_place = @user.board.ships.dup
  end

  def place_ships_prompt
    ship = @ships_to_place.first
    if ship
      "Place your #{ship.name.capitalize} (length: #{ship.size}):"
    else
      nil
    end
  end

  def place_ships_decision_handler(input)
    if ['Y', 'YES'].include?(input.upcase)
      @user.ship_placement_strategy = ManualShipPlacementStrategy
      @current_action = :manually_place_ships
    elsif ['N', 'NO'].include?(input.upcase)
      @user.ship_placement_strategy = RandomShipPlacementStrategy
      @user.place_ships
      @current_action = :take_turn
    end
  end

  def manually_place_ships_handler(input)
    if @ships_to_place.empty?
      @current_action = :take_turn
    else
      ship = @ships_to_place.first
      @user.ship_placement_strategy.place_ship(ship, @user.board, input)
      @messages << "Placed #{ship.name.capitalize}"
      @ships_to_place.shift
      if @ships_to_place.empty?
        @current_action = :take_turn
      end
    end
  end

end