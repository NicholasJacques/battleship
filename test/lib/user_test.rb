require 'minitest/autorun'
require './lib/user.rb'
require './lib/board/board.rb'

describe User do
  describe '#lost?' do
    it 'returns true if all of the users ships have been sunk' do
      # skip
      user = User.new
      user.board = Board.new(Game.ships)
      user.board.ships.each {|ship| ship.size.times { ship.hit } }
      assert_equal true, user.lost?
    end

    it 'returns false if none of the ships have been hit' do
      # skip
      user = User.new
      user.board = Board.new(Game.ships)
      assert_equal false, user.lost?
    end

    it 'returns false if some of the ships have been sunk' do
      # skip
      user = User.new
      user.board = Board.new(Game.ships)
      user.board.ships.take(2).each {|ship| ship.size.times { ship.hit } }
      assert_equal false, user.lost?
    end
  end
end