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
    # @messages = ["Line 1", "Line 2", "Line 3", "Line 4", "Placed carrier", "Placed battleship", "Placed cruiser", "Ship must be placed vertically or horizontal in sequential cells."]
    # @messages = ["Ship must be placed vertically or horizontal in sequential cells."]
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
        handler: :take_turn_handler,
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
      @current_action = :user_turn
    end
  end

  def manually_place_ships_handler(input)
    if @ships_to_place.empty?
      @current_action = :user_turn
    else
      ship = @ships_to_place.first
      success, messages = ManualShipPlacementStrategy.place_ship(ship, user.board, input)
      @messages += messages
      if success
        @ships_to_place.shift
      end
      if @ships_to_place.empty?
        @current_action = :user_turn
      end
    end
  end

  def take_turn_handler(position)
    position = position.upcase
    user_result = user.fire(position)
    if user_result.is_hit
      @messages << "Hit! You fired at #{position} and hit a ship!"
      if user_result.is_sunk
        @messages << "You sunk their #{user_result.ship.name}!"
      end
    else
      @messages << "Miss! You fired at #{position} and missed."
    end
    @current_action = :ai_turn
  end

  def ai_turn_handler
    sleep(1)
    ai_result = ai.fire
    if ai_result.is_hit
      @messages << "Hit! They fired at #{ai_result.position} and hit your #{ai_result.ship.name}"
      if ai_result.is_sunk
        @messages << "They sunk your #{ai_result.ship.name}!"
      end
    else
      @messages << "Miss! They fired at #{ai_result.position} and missed."
    end
    @current_action = :user_turn
  end

end