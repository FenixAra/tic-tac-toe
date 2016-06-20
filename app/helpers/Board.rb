# Board.rb : Defines the board as an assimilation of cells

$LOAD_PATH << '.'

require 'Cell'

module TicTacToe
    class Board
        def initialize()
            @boardArray = Array.new(3) {Array.new(3) {Cell.new}} 
        @numberOfMoves = 0
        end
    
        def printCurrentBoard()
            for i in 0 .. 2
                for j in 0 .. 2
                    res = @boardArray[i][j]
                    print "#{res.getCell} "
                end
                puts ""
            end
        end
    
        def setCellInBoard(x, y, value)
            if x < 3 && y < 3
                if @boardArray[x][y].getCell() == "-"
                    @boardArray[x][y].setCell(value)
                    @numberOfMoves += 1
                    puts "Value set at given location"
                    return true
                end
                puts "Cell already occupied, try a different cell"
            else
                puts "Invalid coordinates!!"
            end
            return false
        end
        
        def isGameOver(x, y, value)
            # Checking for draw
            if @numberOfMoves == 9
                return 3
            end
            
            # Checking for column win
            for i in 0 .. 2 
                if @boardArray[x][i].getCell != value
                    break
                end
                if i == 2
                    return (value == "X" ? 1 : (value == "O" ? 2 : 0))
                end
            end
        
            # Checking for row win
            for i in 0 .. 2
                if @boardArray[i][y].getCell != value
                    break
                end
                if i == 2
                    return (value == "X" ? 1 : (value == "O" ? 2 : 0))
                end
            end
            
            # Checking for left diagonal win
            for i in 0 .. 2
                if @boardArray[i][i].getCell != value
                    break
                end
                if i == 2
                    return (value == "X" ? 1 : (value == "O" ? 2 : 0))
                end
            end
            
            # Checking for right diagonal win
            for i in 0 .. 2
                if @boardArray[i][2 - i].getCell != value
                    break
                end
                if i == 2
                    return (value == "X" ? 1 : (value == "O" ? 2 : 0))
                end
            end
            
            return 0            # The game is still on
        end
    end
end