#######################
# LEGENDA DO BOARD    #
#  unknown_cell: 'O', #
#  clear_cell: '_',   #
#  bomb: '*',         #
#  flag: 'F'          #
#######################

require File.expand_path('lib/minesweeper.rb')

width, height, num_mines = 10, 20, 50
game = Minesweeper.new(width, height, num_mines)

#game.board_state(true)
#game.board_state
#puts "\n\n"

while (game.stil_playing)
  valid_move = game.play(rand(width), rand(height))
  valid_flag = game.flag(rand(width), rand(height))
  if valid_move or valid_flag
    puts 'BOARD STATE:'
    game.board_state
  end
end

puts "Fim do jogo!"
if game.victory
  puts "Você venceu!"
else
  puts "Você perdeu! As minas eram:"
  game.board_state true
end
