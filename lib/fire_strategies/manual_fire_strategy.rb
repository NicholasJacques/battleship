class ManualFireStrategy
  def self.fire_upon(board)
    puts "Select your target: "
    position = gets.chomp.upcase
    board.fire(position)
  end
end