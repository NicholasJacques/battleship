require './lib/ui/ui.rb'

module UI
  class GameConsole < Base
    def initialize(parent, game)
      super(parent)
      @game = game
      @window = @parent.window.derwin(3, 54, 1, 0)
      @window.box('|', '-')
    end

    def set_content
      @window.setpos(1, 3)
    end

    def prompt
      show_cursor
      @window.setpos(1, 2)
      answer = nil
      until answer
        answer = @window.getstr
        if ['Y', 'N'].include?(answer.upcase)
          answer = answer.upcase
        else
          answer = nil
          reset_prompt
        end
      end
      @window.clear
      hide_cursor
      refresh
      answer
    end

    def reset_prompt
      @window.setpos(1, 1)
      @window.addstr(' ' * (@window.maxx - 2))
      @window.setpos(1, 2)
      @window.refresh
    end

  end
end