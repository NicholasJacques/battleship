require 'curses'
require './lib/ui/board.rb'
require './lib/ui/game_screen.rb'
require './lib/ui/start_screen.rb'

module UI
  class UI
    attr_reader :window
  
    def initialize(game)
      @game = game
      @window = Curses.init_screen
      hide_cursor
    end

    def start_screen
      @start_screen ||= StartScreen.new(@window)
    end

    def game_screen
      @game_screen ||= GameScreen.new(@window, @game)
    end

    def start
      start_screen.render
      @window.getch
      start_screen.resize_window_prompt
      @game.user.name = start_screen.ask_name
    end

    def render_game_screen
      @window.clear
      game_screen.render
    end
  
    def clear_screen
      @window.clear
      @window.refresh
    end

    def hide_cursor
      Curses.curs_set(0)
    end

    def show_cursor
      Curses.curs_set(1)
    end
    
  end
end
