require_relative './board/board.rb'
require_relative './ship.rb'
require_relative './user.rb'
require './lib/board/ship_placer.rb'

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
    play_game
  end

  def welcome
    puts "Welcome to BATTLESHIP \n What is your name?"
  end

  def ask_name
    puts "What is your name?"
    name = gets.chomp
    @user = User.new(name)
  end

  def acknowledge_player
    puts "Ok, #{@user.name}, let's go!"
  end

  def setup_boards
    @user.board = Board.new(Game.ships)
    puts @user.board.render

    puts "Do you want to use auto-place your ships? [Y] [N]?"
    input = gets.chomp
    if input.upcase == 'Y'
      ShipPlacer.place_all(@user.board)
    else
      @user.board.ships.each do |ship|
        ship_placed = false
        until ship_placed do
          puts "\nPlace your #{ship.name.capitalize} (length: #{ship.size})"
          position = gets.chomp
          begin
            @user.board.place(position, ship)
          rescue ShipPlacementError => error
            puts error.errors
            puts "Try again"
            next
          end
          ship_placed = true
        end
      end
    end
    @ai = User.new
    @ai.board = Board.new(Game.ships)
    ShipPlacer.place_all(@ai.board)
    puts "Computer's Board:"
    puts @ai.board.render(show_ships: false)
    puts "Your Board:"
    puts @user.board.render
    game_loop
  end

  def place_ai_ships
    ShipPlacer.new(ships, @ai_board).place
  end

  def game_loop
    game_over = false
    until game_over do
      user_turn
      computer_turn
      game_over = is_game_over?
    end
  end

  def user_turn
    puts "Select your target: "
    position = gets.chomp.upcase
    @ai.board.fire(position)
    puts @ai.board.render(show_ships: false)
  end

  def computer_turn
    puts "Computer's turn:"
    position = @user.board.cells.filter {|k, v| v.hit == false}.keys.sample
    @user.board.fire(position)
    puts @user.board.render
  end

  def is_game_over?
    @user.lost? || @ai.lost?
  end
end