# Cell.rb : Defines a cell, the basic building block of the Tic-Tac-Toe board

module TicTacToe
    class Cell
        def initialize()
            @x = 0
            @y = 0
            @value = "-"
        end
        
        def setCell(value)
            @value = value
        end
        
        def getCell()
            return @value
        end
    end
end