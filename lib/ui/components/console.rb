require './lib/ui/components/base.rb'

module UI
  class Console < Window
    def initialize(*args)
      super(*args)
    end

    def render
      @window.box('|', '-')
      @window.setpos(1, 2)
      @window.refresh
    end

    def prompt(validate_response)
      Curses.curs_set(1)
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

    def get_user_input_string
      input = @window.getstr
      if input == 'quit'
        Curses.close_screen
        exit
      else
        input
      end
    end

  end
end