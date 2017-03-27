#######################
# LEGENDA DO BOARD    #
#  unknown_cell: 'O', #
#  clear_cell: '_',   #
#  bomb: '*',         #
#  flag: 'F'          #
#######################

require File.expand_path('lib/minesweeper.rb')
require File.expand_path('lib/simple_printer.rb')

width, height, num_mines = 10, 20, 50
game = Minesweeper.new(width, height, num_mines)

printer = SimplePrinter.new

while (game.stil_playing)
  valid_move = game.play(rand(width), rand(height))
  valid_flag = game.flag(rand(width), rand(height))
  if valid_move or valid_flag
    puts 'BOARD STATE:'
    printer.print game.board_state
    puts ""
  end
end

puts "Fim do jogo!"
if game.victory
  puts "Você venceu!"
else
  puts "Você perdeu! As minas eram:"
  printer.print game.board_state true
end
