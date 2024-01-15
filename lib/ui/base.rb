class Base
  def initialize(parent)
    @parent = parent
    @window = nil
  end

  def center_text(text)
    height, width = @window.maxy, @window.maxx
    x = (width - text.length) / 2
    y = height / 2
    @window.setpos(y, x)
    @window.addstr(text)
  end

  def footer_text(text)
    height, width = @window.maxy, @window.maxx
    x = (width - text.length) / 2
    y = height - 1
    @window.setpos(y, x)
    @window.addstr(text)
  end

  def x_center
    @window.maxx / 2
  end

  def y_center
    @window.maxy / 2
  end

  def hide_cursor
    Curses.curs_set(0)
  end

  def show_cursor
    Curses.curs_set(1)
  end

end