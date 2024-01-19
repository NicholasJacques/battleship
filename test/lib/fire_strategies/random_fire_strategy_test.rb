require 'minitest/autorun'
require './lib/fire_strategies/random_fire_strategy.rb'
require './lib/board.rb'
require './lib/ship.rb'
require './lib/user.rb'


# Diagram Key:
# A lowercase ship letter represents a ship that has been hit
# '#' represents a valid location for the next hit
# 'X' represents a miss (a hit on an unoccupied cell)

describe RandomFireStrategy do
  describe '#fire' do
    describe 'when it has fired once previously and it was a hit' do
      it 'fires in a random adjacent cell' do
        #   1 2 3 4 5 6 7 8 9 10
        # A . . . . . . . . . .
        # B . . . . . . . . . .
        # C . . . . . . . . . .
        # D . . . . # . . . . .
        # E . . . # d # D D . .
        # F . . . . # . . . . .
        # G . . . . . . . . . .
        # H . . . . . . . . . .
        # I . . . . . . . . . .
        # J . . . . . . . . . .

        # skip
        ship = Ship.new('battleship', 4)
        opponent_board = Board.new([ship])
        user = User.new
        ship_positions = ['E5', 'E6', 'E7', 'E8']
        opponent_board.place(ship_positions, ship)
        user.fire_history = [
          opponent_board.fire('E5')
        ]
        fire_strategy = RandomFireStrategy.new(opponent_board, user)

        result = fire_strategy.fire
        assert_includes ['E4', 'E6', 'D5', 'F5'], result.position
        refute_includes opponent_board.cells.keys - ['E5', 'E4', 'E6', 'D5', 'F5'], result.position
      end
    end

    describe 'when it has fired twice, with a hit, followed by a miss' do
      it 'fires in a random cell adjacent to the hit that has not already been hit' do
        #   1 2 3 4 5 6 7 8 9 10
        # A . . . . . . . . . .
        # B . . . . . . . . . .
        # C . . . . . . . . . .
        # D . . . . X . . . . .
        # E . . . # d # D D . .
        # F . . . . # . . . . .
        # G . . . . . . . . . .
        # H . . . . . . . . . .
        # I . . . . . . . . . .
        # J . . . . . . . . . .

        # skip
        ship = Ship.new('battleship', 4)
        opponent_board = Board.new([ship])
        user = User.new
        ship_positions = ['E5', 'E6', 'E7', 'E8']
        opponent_board.place(ship_positions, ship)
        user.fire_history = [
          opponent_board.fire('E5'),
          opponent_board.fire('D5'),
        ]
        fire_strategy = RandomFireStrategy.new(opponent_board, user)

        result = fire_strategy.fire
        assert_includes ['E4', 'E6', 'F5'], result.position
        refute_includes opponent_board.cells.keys - ['E5', 'E4', 'E6', 'F5', 'D5'], result.position
      end
    end

    describe 'when it has fired three times: a hit followed by two misses' do
      it 'fires in one of the two remainings cells adjacent to the hit that has not already been hit' do
        #   1 2 3 4 5 6 7 8 9 10
        # A . . . . . . . . . .
        # B . . . . . . . . . .
        # C . . . . . . . . . .
        # D . . . . X . . . . .
        # E . . . # d # D D . .
        # F . . . . X . . . . .
        # G . . . . . . . . . .
        # H . . . . . . . . . .
        # I . . . . . . . . . .
        # J . . . . . . . . . .

        # skip
        ship = Ship.new('battleship', 4)
        opponent_board = Board.new([ship])
        user = User.new
        ship_positions = ['E5', 'E6', 'E7', 'E8']
        opponent_board.place(ship_positions, ship)
        user.fire_history = [
          opponent_board.fire('E5'),
          opponent_board.fire('D5'),
          opponent_board.fire('F5'),
        ]
        fire_strategy = RandomFireStrategy.new(opponent_board, user)

        result = fire_strategy.fire
        assert_includes ['E4', 'E6'], result.position
        refute_includes opponent_board.cells.keys - ['E5', 'E4', 'E6', 'F5', 'D5'], result.position
      end
    end

    describe 'when it has a hit followed by three misses' do
      it 'fires in the last remaining cell adjacent to the hit that has not already been hit' do
        #   1 2 3 4 5 6 7 8 9 10
        # A . . . . . . . . . .
        # B . . . . . . . . . .
        # C . . . . . . . . . .
        # D . . . . X . . . . .
        # E . . . X d # D D . .
        # F . . . . X . . . . .
        # G . . . . . . . . . .
        # H . . . . . . . . . .
        # I . . . . . . . . . .
        # J . . . . . . . . . .

        # skip
        ship = Ship.new('battleship', 4)
        opponent_board = Board.new([ship])
        user = User.new
        ship_positions = ['E5', 'E6', 'E7', 'E8']
        opponent_board.place(ship_positions, ship)
        user.fire_history = [
          opponent_board.fire('E5'),
          opponent_board.fire('D5'),
          opponent_board.fire('F5'),
          opponent_board.fire('E4'),
        ]
        fire_strategy = RandomFireStrategy.new(opponent_board, user)

        assert_equal 'E6', fire_strategy.fire.position
      end
    end

    describe 'when there are adjacent horizontal hits' do
      describe 'when previous two hits are adjacent to one another' do
        it 'determines the cardinality of the adjacent cells and fires in line with them' do
          #   1 2 3 4 5 6 7 8 9 10
          # A . . . . . . . . . .
          # B . . . . . . . . . .
          # C . . . . . . . . . .
          # D . . . . . . . . . .
          # E . . . . # d d # . .
          # F . . . . . . . . . .
          # G . . . . . . . . . .
          # H . . . . . . . . . .
          # I . . . . . . . . . .
          # J . . . . . . . . . .

          # skip
          ship = Ship.new('battleship', 4)
          opponent_board = Board.new([ship])
          user = User.new
          ship_positions = ['E5', 'E6', 'E7', 'E8']
          opponent_board.place(ship_positions, ship)
          user.fire_history = [
            opponent_board.fire('E6'),
            opponent_board.fire('E7'),
          ]
          fire_strategy = RandomFireStrategy.new(opponent_board, user)
  
          result = fire_strategy.fire
          assert_includes ['E5', 'E8'], result.position
          refute_includes opponent_board.cells.keys - ['E5', 'E6', 'E7', 'E8'], result.position
        end
      end
      
      describe 'when there are two adjacent hits adjacent to a miss' do
        it 'fires in the remaining adjacent cell that is not hit' do
          #   1 2 3 4 5 6 7 8 9 10
          # A . . . . . . . . . .
          # B . . . . . . . . . .
          # C . . . . . . . . . .
          # D . . . . . . . . . .
          # E . . . . D # d d X .
          # F . . . . . . . . . .
          # G . . . . . . . . . .
          # H . . . . . . . . . .
          # I . . . . . . . . . .
          # J . . . . . . . . . .

          # skip
          ship = Ship.new('battleship', 4)
          opponent_board = Board.new([ship])
          user = User.new
          ship_positions = ['E5', 'E6', 'E7', 'E8']
          opponent_board.place(ship_positions, ship)
          user.fire_history = [
            opponent_board.fire('E7'),
            opponent_board.fire('E9'),
            opponent_board.fire('E8'),
          ]
          fire_strategy = RandomFireStrategy.new(opponent_board, user)
    
          assert_equal 'E6', fire_strategy.fire.position
        end
      end

      describe 'whene there are three adjacent hits' do
        it 'fires in one of the two adjacent cells in line with the hits' do
          #   1 2 3 4 5 6 7 8 9 10
          # A . . . . . . . . . .
          # B . . . . . . . . . .
          # C . . . . . . . . . .
          # D . . . . . . . . . .
          # E . . . # d d d # . .
          # F . . . . . . . . . .
          # G . . . . . . . . . .
          # H . . . . . . . . . .
          # I . . . . . . . . . .
          # J . . . . . . . . . .

          # skip
          ship = Ship.new('battleship', 4)
          opponent_board = Board.new([ship])
          user = User.new
          ship_positions = ['E5', 'E6', 'E7', 'E8']
          opponent_board.place(ship_positions, ship)
          user.fire_history = [
            opponent_board.fire('E6'),
            opponent_board.fire('E7'),
            opponent_board.fire('E5'),
          ]
          fire_strategy = RandomFireStrategy.new(opponent_board, user)

          assert_includes ['E4', 'E8'], fire_strategy.fire.position
        end
      end

      describe 'when adjacent hits and the last hit misses the end of the ship' do
        it 'tries the other side of the ship' do
          #   1 2 3 4 5 6 7 8 9 10
          # A . . . . . . . . . .
          # B . . . . . . . . . .
          # C . . . . . . . . . .
          # D . . . . . . . . . .
          # E . . . . # b b b X .
          # F . . . . . . . . . .
          # G . . . . . . . . . .
          # H . . . . . . . . . .
          # I . . . . . . . . . .
          # J . . . . . . . . . .

          # skip
          ship = Ship.new('battleship', 4)
          opponent_board = Board.new([ship])
          user = User.new
          ship_positions = ['E5', 'E6', 'E7', 'E8']
          opponent_board.place(ship_positions, ship)
          user.fire_history = [
            opponent_board.fire('E6'),
            opponent_board.fire('E7'),
            opponent_board.fire('E8'),
            opponent_board.fire('E9'),
          ]
          fire_strategy = RandomFireStrategy.new(opponent_board, user)

          assert_equal 'E5', fire_strategy.fire.position
        end
      end

      describe 'when there adjacet hits and adjacent misses in both directions' do
        it 'fires in adjacent cells in line with either direction' do
          ship = Ship.new('carrier', 5)
          opponent_board = Board.new([ship])
          user = User.new
          ship_positions = ['F4', 'F5', 'F6', 'F7', 'F8']
          opponent_board.place(ship_positions, ship)
          user.fire_history = [
            opponent_board.fire('F7'),
            opponent_board.fire('E7'),
            opponent_board.fire('G7'),
            opponent_board.fire('F6'),
          ]
          fire_strategy = RandomFireStrategy.new(opponent_board, user)

          assert_includes ['F5', 'F8'], fire_strategy.fire.position
        end
      end
    end

    describe 'when the adjacent hits are verticle' do
      describe 'when previous two hits are adjacent to one another' do
        it 'determines the cardinality of the hits and fires in one of the adjacent cells in line with them' do
          #   1 2 3 4 5 6 7 8 9 10
          # A . . . . . . . . . .
          # B . . . . # . . . . .
          # C . . . . d . . . . .
          # D . . . . d . . . . .
          # E . . . . # . . . . .
          # F . . . . D . . . . .
          # G . . . . . . . . . .
          # H . . . . . . . . . .
          # I . . . . . . . . . .
          # J . . . . . . . . . .

          # skip
          ship = Ship.new('battleship', 4)
          opponent_board = Board.new([ship])
          user = User.new
          ship_positions = ['C5', 'D5', 'E5', 'F5']
          opponent_board.place(ship_positions, ship)
          user.fire_history = [
            opponent_board.fire('C5'),
            opponent_board.fire('D5'),
          ]
          fire_strategy = RandomFireStrategy.new(opponent_board, user)
  
          result = fire_strategy.fire
          assert_includes ['B5', 'E5'], result.position
          refute_includes opponent_board.cells.keys - ['B5', 'C5', 'D5', 'E5'], result.position
        end
      end

      describe 'when there are two adjacent hits adjacent to a miss' do
        it 'fires in the remaining adjacent cell that is not hit' do
          #   1 2 3 4 5 6 7 8 9 10
          # A . . . . . . . . . .
          # B . . . . X . . . . .
          # C . . . . d . . . . .
          # D . . . . d . . . . .
          # E . . . . # . . . . .
          # F . . . . D . . . . .
          # G . . . . . . . . . .
          # H . . . . . . . . . .
          # I . . . . . . . . . .
          # J . . . . . . . . . .

          # skip
          ship = Ship.new('battleship', 4)
          opponent_board = Board.new([ship])
          user = User.new
          ship_positions = ['C5', 'D5', 'E5', 'F5']
          opponent_board.place(ship_positions, ship)
          user.fire_history = [
            opponent_board.fire('C5'),
            opponent_board.fire('B5'),
            opponent_board.fire('D5'),
          ]
          fire_strategy = RandomFireStrategy.new(opponent_board, user)

          assert_equal 'E5', fire_strategy.fire.position
        end
      end

      describe 'when there are three adjacent hits' do
        it 'fires in one of the two adjacent cells in line with the hits' do
          #   1 2 3 4 5 6 7 8 9 10
          # A . . . . . . . . . .
          # B . . . . # . . . . .
          # C . . . . d . . . . .
          # D . . . . d . . . . .
          # E . . . . d . . . . .
          # F . . . . # . . . . .
          # G . . . . . . . . . .
          # H . . . . . . . . . .
          # I . . . . . . . . . .
          # J . . . . . . . . . .

          # skip
          ship = Ship.new('battleship', 4)
          opponent_board = Board.new([ship])
          user = User.new
          ship_positions = ['C5', 'D5', 'E5', 'F5']
          opponent_board.place(ship_positions, ship)
          user.fire_history = [
            opponent_board.fire('D5'),
            opponent_board.fire('C5'),
            opponent_board.fire('E5'),
          ]
          fire_strategy = RandomFireStrategy.new(opponent_board, user)

          assert_includes ['B5', 'F5'], fire_strategy.fire.position
        end
      end

      describe 'when adjacent hits and the last hit misses the end of the ship' do
        it "tries the other side of the ship" do
          #   1 2 3 4 5 6 7 8 9 10
          # A . . . . . . . . . .
          # B . . . . . . . . . .
          # C . . . . # . . . . .
          # D . . . . b . . . . .
          # E . . . . b . . . . .
          # F . . . . b . . . . .
          # G . . . . X . . . . .
          # H . . . . . . . . . .
          # I . . . . . . . . . .
          # J . . . . . . . . . .
          
          # skip
          ship = Ship.new('battleship', 4)
          opponent_board = Board.new([ship])
          user = User.new
          ship_positions = ['C5', 'D5', 'E5', 'F5']
          opponent_board.place(ship_positions, ship)
          user.fire_history = [
            opponent_board.fire('D5'),
            opponent_board.fire('E5'),
            opponent_board.fire('F5'),
            opponent_board.fire('G5'),
          ]
          fire_strategy = RandomFireStrategy.new(opponent_board, user)
          assert_equal 'C5', fire_strategy.fire.position
        end
      end

      describe 'when there are two adjacent hits and all adjects cells have also been hit' do
        it 'fires at the other side of the column' do
          #   1 2 3 4 5 6 7 8 9 10
          # A . . . . . . . . . .
          # B . . . . . . . . . .
          # C . . . . . . . . . .
          # D . . . . . . . . . .
          # E . . . . . . . . X .
          # F . . . . . . . . B .
          # G . . . . . . . . # .
          # H . . . . . . . . b .
          # I . . . . . . . X b X
          # J . . . . . . . . X .

          # skip
          ship = Ship.new('battleship', 4)
          opponent_board = Board.new([ship])
          user = User.new
          ship_positions = ['F9', 'G9', 'H9', 'I9']
          opponent_board.place(ship_positions, ship)
          user.fire_history = [
            opponent_board.fire('E9'),
            opponent_board.fire('I8'),
            opponent_board.fire('J9'),
            opponent_board.fire('I10'),
            opponent_board.fire('I9'),
            opponent_board.fire('H9'),
          ]
          fire_strategy = RandomFireStrategy.new(opponent_board, user)

          assert_equal 'G9', fire_strategy.fire.position
        end
      end
    end

    # describe 'when there are adjacent hits in both directions' do
    #   it 'fires in adjacent cells in line with either direction' do
    #     # I'm not sure this situation is possible
    #     ship_1 = Ship.new('battleship', 4)
    #     ship_2 = Ship.new('destroyer', 3)
    #     opponent_board = Board.new([ship_1, ship_2])
    #     user = User.new
    #     ship_1_positions = ['C5', 'D5', 'E5', 'F5']
    #     ship_2_positions = ['G4', 'G5', 'G6']
    #     opponent_board.place(ship_1_positions, ship_1)
    #     opponent_board.place(ship_2_positions, ship_2)
    #     opponent_board.fire('G5')
    #     opponent_board.fire('G6')
    #     opponent_board.fire('G4')
    #   end
    # end

    # describe 'when there are three adjacent hits in a line' do
    #   it 'fires in one of the two adjacent cells in line with the hits' do
    #   end

    # end

    # describe 'when the ship is sunk' do
    #   it 'fires in a random cell that has not already been hit' do
    #     ship = Ship.new('battleship', 4)
    #     opponent_board = Board.new([ship])
    #     user = User.new
    #     ship_positions = ['E5', 'E6', 'E7', 'E8']
    #     opponent_board.place(ship_positions, ship)
    #     opponent_board.fire('E5')
    #     opponent_board.fire('E6')
    #     opponent_board.fire('E7')
    #     opponent_board.fire('E8')
    #     user.fire_history = [opponent_board.cells['E7'], opponent_board.cells['E8'], opponent_board.cells['E9']]
    #     fire_strategy = RandomFireStrategy.new(opponent_board, user)



    #   end
    # end
  end
end