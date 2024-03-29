module Positionable

  def center_x(line, text)
    width = window.maxx
    x = (width - text.length) / 2
    window.setpos(line, x)
    window.addstr(text)
  end

  def center_text(text)
    height, width = window.maxy, window.maxx
    x = (width - text.length) / 2
    y = height / 2
    window.setpos(y, x)
    window.addstr(text)
  end

  def header_text(text)
    center_x(1, text)
  end

  def footer_text(text)
    height, width = window.maxy, window.maxx
    x = (width - text.length) / 2
    y = height - 1
    window.setpos(y, x)
    window.addstr(text)
  end

  def x_center
    window.maxx / 2
  end

  def y_center
    window.maxy / 2
  end
end
