require './lib/ui/ui.rb'

module UI
  class GameConsole < Base
    def initialize(parent, row, column, game)
      super(parent)
      @game = game
      @window = @parent.window.derwin(3, 54, row, column)
      @window.box('|', '-')
    end

    # def set_content
    #   @window.setpos(1, 3)
    # end

    def prompt(validate_response)
      show_cursor
      Curses.echo
      @window.setpos(1, 2)
      loop do
        answer = get_user_input_string
        if validate_response.call(answer.upcase)
          reset_prompt
          return answer.upcase
        else
          reset_prompt
        end
      end
    end

    def reset_prompt
      @window.setpos(1, 1)
      @window.addstr(' ' * (@window.maxx - 2))
      @window.setpos(1, 2)
      @window.refresh
    end

  end
end