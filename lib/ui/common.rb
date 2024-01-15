require 'curses'

module Common

  def center_x(window, line, text)
    width = window.maxx
    x = (width - text.length) / 2
    window.setpos(line, x)
    window.addstr(text)
  end

end