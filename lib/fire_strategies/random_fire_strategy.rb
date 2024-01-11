class RandomFireStrategy
  def self.fire_upon(board)
    position = board.cells.filter {|k, v| v.hit == false}.keys.sample
    board.fire(position)
  end
end