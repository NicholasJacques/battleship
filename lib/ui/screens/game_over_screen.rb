module UI
  include Positionable

  class GameOverScreen
    def initialize(game_state)
      @game_state = game_state
      @window = Curses.stdscr
    end

    def render
      header_text("BATTLESHIP")
    end
  end

end