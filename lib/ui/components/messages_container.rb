module UI
  class Messages < Window
    def initialize(*args)
      super(*args)
    end

    def render
      @window.clear
      @window.box('|', '-')
      available_rows = @window.maxy - 2
      available_columns = @window.maxx - 2
      current_row = @window.maxy - 2
      @game_state.messages.reverse.each_with_index do |message, index|
        if message.length <= available_columns
          if available_rows >= 1
            @window.setpos(current_row, 2)
            @window.addstr(message)
            current_row -= 1
            available_rows -= 1
          else
            break
          end
        else
          lines = []
          current_line = ''
          message.split.each do |word|
            if current_line.length + word.length + 1 <= available_columns
              current_line += word + ' '
            elsif current_line.length + word.length <= available_columns
              current_line += word
            else
              lines << current_line
              current_line = '  ' + word + ' '
            end
          end
          if !current_line.empty?
            lines << current_line
          end
          current_line = ''

          if lines.length > available_rows
            break
          else
            lines.reverse.each_with_index do |line|
              @window.setpos(current_row, 2)
              @window.addstr(line)
              current_row -= 1
              available_rows -= 1
            end
          end
        end
      end
      @window.refresh
    end

  end
end
