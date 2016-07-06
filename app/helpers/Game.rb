# # Game.rb : The main controller for the game

# $LOAD_PATH << '.'

# require 'Player'
# require 'Board'

# module TicTacToe
#     board = Board.new
#     player1 = Player.new
#     player2 = Player.new

#     print "Enter the name of Player1 (X): "
#     player1.setName(gets.chomp)
#     player1.setValue("X")
    
#     print "\nEnter the name of Player2 (O): "
#     player2.setName(gets.chomp)
#     player2.setValue("O")

#     puts "The following is the initial state of the board: "
#     board.printCurrentBoard

#     gameOverFlag = 0
#     currentPlayer = player1
#     otherPlayer = player2

#     begin
#         puts "The current player is #{currentPlayer.getName}!!"
#         inputCheck = 0
#         begin
#             print "Enter the x-coordinate for your mark (1-3): "
#             x = gets.chomp.to_i
#             print "Enter the y-coordinate for your mark (1-3): "
#             y = gets.chomp.to_i
#             if x < 1 || x > 3
#                 puts "Invalid x-coordinate, enter coordinates again.."
#             end
#             if y < 1 || y > 3
#                 puts "Invalid y-coordinate, enter coordinates again.."
#             end
#             if x.between?(1, 3) && y.between?(1, 3)
#                 inputCheck = 1
#             end
#         end while inputCheck == 0
#         board.setCellInBoard(x-1, y-1, currentPlayer.getValue)
#         puts "The following is the current board: "
#         board.printCurrentBoard
#         gameOverFlag = board.isGameOver(x-1, y-1, currentPlayer.getValue)
#         currentPlayer, otherPlayer = otherPlayer, currentPlayer
#     end while gameOverFlag == 0
    
#     if gameOverFlag == 3
#         puts "The match is a draw!!"
#     elsif gameOverFlag == 1
#         puts "The winner is #{player1.getName}!!"
#     else
#         puts "The winner is #{player2.getName}!!"
#     end
# end
