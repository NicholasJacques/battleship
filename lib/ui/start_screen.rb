require 'curses'

class StartScreen
  attr_reader :screen

  def initialize(window)
    @window = window
  end

  def display
    start_screen
  end

  def start_screen
    @window.center_text("Battleship!")
    @window.footer_text("Press any key to continue")
    @window.refresh
    @window.getch
    resize_window_prompt
  end

  def resize_window_prompt
    Signal.trap("SIGWINCH") do
      resize_window_guide_handler
    end
    resize_window_guide
    loop do
      input = @window.getch
      if input != 410
        break
      end
      sleep(0.1)
    end
    sleep(100)
  end

  def resize_window_guide
    @window.center_text("Battleship!")
    [ 
      "Before we begin, please resize your window to 60x40",
      "Current Size: #{@window.maxx}x#{@window.maxy}",
    ].each_with_index do |line, i|
      x = (@window.maxx - line.length) / 2
      y = @window.y_center + i + 1
      @window.setpos(y, x)
      @window.addstr(line)
    end

    @window.footer_text("Press any key when you are done")
    @window.refresh
  end

  def resize_window_guide_handler
    Curses.close_screen
    @window.refresh
    resize_window_guide
  end

end