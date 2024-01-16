class ManualFireStrategy
  def initialize(board)
    @board = board
  end

  def fire(position)
    @board.fire(position)
  end
end