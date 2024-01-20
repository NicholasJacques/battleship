require 'forwardable'
require 'curses'

require './lib/game.rb'
require './lib/ship_placement_strategies/random_ship_placement_strategy.rb'
require './lib/ship_placement_strategies/manual_ship_placement_strategy.rb'

class GameStateManager
  extend Forwardable

  def self.create_game
    new
  end

  attr_reader :game, :current_action, :ships_to_place, :messages
  def_delegators :@game, :user, :ai, :over?

  def initialize
    @game = Game.new(self)
    @current_action = :place_ships_decision
    @ships_to_place = @game.user.board.ships.dup
    @messages = []
    setup_game
  end

  def setup_game
    game.ai.fire_strategy = FireStrategyFactory.create(:random, game.user.board, user: game.ai)
    RandomShipPlacementStrategy.place_all(game.ai.board)
  end

  # Accessor methods for game state

  def user_name
    user.name
  end

  def user_board
    user.board
  end

  def ai_board
    ai.board
  end

  # State management

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
      user_turn: {
        prompt: "Select the coordinates to fire at:",
        handler: :user_turn_handler,
      },
      ai_turn: {
        prompt: "Computer Player is taking their turn...",
        handler: :ai_turn_handler,
      },
    }
  end

  def get_prompt
    actions[current_action][:prompt]
  end

  def process_input(input)
    self.send(actions[current_action][:handler], input)
  end

  def current_action_requires_input?
    [:place_ships_decision, :manually_place_ships, :user_turn].include?(current_action)
  end

  def process_action
    self.send(actions[current_action][:handler])
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
      @current_action = :manually_place_ships
    elsif ['N', 'NO'].include?(input.upcase)
      _, messages = RandomShipPlacementStrategy.place_all(user.board)
      @messages += messages
      @messages << "All ships placed! Ready to begin."
      @current_action = :user_turn
    end
  end

  def manually_place_ships_handler(input)
    ship = @ships_to_place.first
    success, messages = ManualShipPlacementStrategy.place_ship(ship, user.board, input)
    @messages += messages
    if success
      @ships_to_place.shift
    end
    if @ships_to_place.empty?
      @messages << "All ships placed! Ready to begin."
      @current_action = :user_turn
    end
  end

  def user_turn_handler(position)
    position = position.upcase
    fire_result = user.fire(position)
    if fire_result.errors.any?
      @messages += fire_result.errors
      return
    elsif fire_result.is_hit
      @messages << "Hit! You fired at #{position} and hit a ship!"
      if fire_result.is_sunk
        @messages << "You sunk their #{fire_result.ship.name}!"
      end
    else
      @messages << "Miss! You fired at #{position} and missed."
    end
    @current_action = :ai_turn
  end

  def ai_turn_handler
    sleep(0.5)
    fire_result = ai.fire
    if fire_result.is_hit
      @messages << "Hit! They fired at #{fire_result.position} and hit your #{fire_result.ship.name}"
      if fire_result.is_sunk
        @messages << "They sunk your #{fire_result.ship.name}!"
      end
    else
      @messages << "Miss! They fired at #{fire_result.position} and missed."
    end
    @current_action = :user_turn
  end

end