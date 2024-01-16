require './lib/ui/ui.rb'


class Runner
  def initialize
    @ui = UI::UI.new
  end

  def run
    @ui.start
  end
end

Runner.new.run