class ManualFireStrategy
  def initialize(board)
    @board = board
  end

  def fire
    puts "Select your target: "
    position = gets.chomp.upcase
    @board.fire(position)
  end
end