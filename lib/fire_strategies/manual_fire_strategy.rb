class ManualFireStrategy
  def initialize(board)
    @board = board
  end

  def fire
    position = gets.chomp.upcase
    @board.fire(position)
  end
end