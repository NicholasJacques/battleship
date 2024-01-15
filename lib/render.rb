


class Render
  SCREEN_HEIGHT = 40
  SCREEN_WIDTH = 60
  RESET_SCREEN_CHAR = "\033[2J"

  def initialize(game)
    @game = game
  end

  def render_lines(lines, footer: nil)
    text_height = lines.count
    top_and_bottom_board = ("-" * SCREEN_WIDTH)

    result = [RESET_SCREEN_CHAR, top_and_bottom_board]
    upper_padding = Array.new(
      ((SCREEN_HEIGHT - 2 - text_height) / 2.0).ceil,
      blank_line,
    )
    lower_padding = Array.new(
      SCREEN_HEIGHT - 2 - text_height - upper_padding.count,
      blank_line,
    )
    lower_padding.pop 1 if footer
    result += upper_padding
    lines.map! { |line| "|" + line.center(SCREEN_WIDTH-2) + "|" }
    result += lines
    result += lower_padding
    if footer
      footer = "|" + footer.center(SCREEN_WIDTH-2) + "|"
      result << footer
    end
    result << top_and_bottom_board

    print result.join("\n") + "\n"
  end

  def blank_line
    "|" + " " * (SCREEN_WIDTH-2) + "|"
  end

  def render_splash(footer: nil)
    render_lines ["BATTLESHIP"], footer: footer
  end

  def render_boards(user_board, opponent_board, show_opponent_ships: true)
    render_lines(["BATTLESHIP", "", ""] + ["Opponent's Board"] + board_lines(opponent_board, show_opponent_ships: false) + [""] + ["Your Board"] + board_lines(user_board), footer: "Select your target...")
  end

  def board_lines(board, show_opponent_ships: true)
    result = []
    result << " " + (1..10).to_a.join(' ')
    result += board.grid.zip(('A'..'J').to_a).map {|row, row_name| row_name + ' ' + row.map {|cell| cell.render(show_ships: show_opponent_ships)}.join(' ') }
    return result
  end
end