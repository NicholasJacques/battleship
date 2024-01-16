require './lib/ui/ui.rb'


class Runner
  def initialize
    @ui = UI::UI.new
  end

  def run
    @ui.start
  end
end

at_exit do
  Curses.close_screen
end
Runner.new.run