require 'forwardable'

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
      take_turn: {
        prompt: "Select the coordinates to fire at:",
      },
    }
  end

  def get_prompt
    actions[current_action][:prompt]
  end

  def process_input(input)
    self.send(actions[current_action][:handler], input)
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
      user.ship_placement_strategy = ManualShipPlacementStrategy
      @current_action = :manually_place_ships
    elsif ['N', 'NO'].include?(input.upcase)
      user.ship_placement_strategy = RandomShipPlacementStrategy
      user.place_ships
      @current_action = :take_turn
    end
  end

  def manually_place_ships_handler(input)
    if @ships_to_place.empty?
      @current_action = :take_turn
    else
      ship = @ships_to_place.first
      user.ship_placement_strategy.place_ship(ship, user.board, input)
      @messages << "Placed #{ship.name.capitalize}"
      @ships_to_place.shift
      if @ships_to_place.empty?
        @current_action = :take_turn
      end
    end
  end

end