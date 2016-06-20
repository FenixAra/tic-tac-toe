# Player.rb : Describes the player properties

module TicTacToe
    class Player
        def initialize()
            @name = ""
            @value = ""
        end
        
        def getName()
            return @name
        end
        
        def getValue()
            return @value
        end
        
        def setName(name)
            @name = name
        end
        
        def setValue(value)
            @value = value
        end
    end
end