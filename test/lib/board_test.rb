require 'minitest/autorun'
require './lib/board.rb'

describe Board do
  describe '#adjacent_cells' do
    it 'returns cells to the n, s, e, w of the given cell' do
      board = Board.new()
      assert_equal [board.cells['D5'], board.cells['F5'], board.cells['E4'], board.cells['E6'], ], board.adjacent_cells('E5')
    end

    it 'does not include cells that are not on the board' do
      board = Board.new()
      assert_equal [board.cells['B1'], board.cells['A2']], board.adjacent_cells('A1') 
      assert_equal [board.cells['I1'], board.cells['J2']], board.adjacent_cells('J1')
      assert_equal [board.cells['B10'], board.cells['A9']], board.adjacent_cells('A10')
      assert_equal [board.cells['I10'], board.cells['J9']], board.adjacent_cells('J10')
      assert_equal [board.cells['B4'], board.cells['A3'], board.cells['A5']], board.adjacent_cells('A4')
      assert_equal [board.cells['D10'], board.cells['F10'], board.cells['E9']], board.adjacent_cells('E10')
      assert_equal [board.cells['D1'], board.cells['F1'], board.cells['E2']], board.adjacent_cells('E1')
      assert_equal [board.cells['I5'], board.cells['J4'], board.cells['J6']], board.adjacent_cells('J5')
    end
  end

  it 'does not accept an argument that is not on the board' do
    board = Board.new()
    assert_raises(ArgumentError) { board.adjacent_cells('K1') }
  end
end