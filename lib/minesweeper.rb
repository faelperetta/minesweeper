require File.expand_path('lib/cell.rb')

# This class is resposible to provide the Minesweeper API
class Minesweeper
  attr_reader :stil_playing, :victory

  def initialize(width, height, num_mines, bombs)
    @width = width
    @height = height
    @num_mines = num_mines
    @victory = false
    @stil_playing = true

    @bombs = generate_bombs(bombs)
    @num_mines = num_mines == 0 ? @bombs.size : num_mines
    @available_plays = (width * height) - @num_mines

    puts "Numero de jogadas disponiveis: #{@available_plays}"

    build_board
  end

  def flag(column, line)
    @board[line][column].flag
  end

  def play(column, line)
    valid = @board[line][column].click
    if valid && @board[line][column].is_bomb
      @victory = false
      @stil_playing = false
    elsif valid
      @available_plays -= 1
      expand column, line

      if (@available_plays == 0)
        @victory = true
        @stil_playing = false
      end
    end
    valid
  end

  def board_state(show_values = false)
    board_state = @board.collect do |line|
      line.collect do |column|
        show_values ? column.value : column.to_s
      end
    end

    board_state
  end

  def board_state_tip()
    board_state = @board.collect.with_index do |line, line_index|
      line.collect.with_index do |column, column_index|
        if not column.is_bomb
          bombs_around = num_bombs(column_index, line_index)
          column.value = bombs_around.size.to_s
          column.value
        end
        column.value
      end
    end
  end

  private

  def num_bombs(column, line)
    bombs_around = @board[line][column].neighbors.select do |item|
      pos = item.split(',').collect { |e| e.to_i  }
      @board[pos[0]][pos[1]].is_bomb
    end
    bombs_around
  end

  def expand(column, line)
    bombs_around = num_bombs(column, line)

    @board[line][column].value = bombs_around.size.to_s

    if bombs_around.size == 0
      @board[line][column].neighbors.each do |position|
        l, c = position.split ','
        l = l.to_i
        c = c.to_i

        if !@board[l][c].is_bomb && !@board[l][c].has_flag && @board[l][c].unknown
          @board[l][c].open
          @available_plays -= 1
          expand(c,l)
        end
      end
    end
  end

  def build_board
    @board = []

    bombs = @bombs

    num_of_lines = @height - 1
    num_of_columns = @width - 1

    for line in (0..num_of_lines)
      @board[line] = []
      for column in (0..num_of_columns)
        key = [line, column]
        cell = bombs.key?(key) ? bombs[key] : Cell.new
        @board[line][column] = cell

        set_neighbors(line, column)
      end
    end

  end

  def set_neighbors(line, column)
    min_line = line - 1
    max_line = line + 1
    min_column = column - 1
    max_column = column + 1

    min_line = min_line < 0 ? 0 : min_line
    max_line = max_line == @height ? @height - 1 : max_line

    min_column = min_column < 0 ? 0 : min_column
    max_column = max_column == @width ? @width - 1 : max_column

    for i in (min_line..max_line)
      next if !@board[i]
      for x in (min_column..max_column)
        next if i == line && x == column or !@board[i][x]
        @board[line][column].add_neighbor "#{i},#{x}"
        @board[i][x].add_neighbor "#{line},#{column}"
      end
    end

  end

  def generate_bombs(bombs)
    bombs_hash = {}

    if bombs && bombs.size > 0
      bombs.each do |position|
        bombs_hash[position] = Cell.new "*" if not bombs_hash.key?(position)
      end
      return bombs_hash
    end


    while(bombs_hash.size < @num_mines)
      line = rand(@height)
      column = rand(@width)
      key = [line, column]
      bombs_hash[key] = Cell.new "*" if not bombs_hash.key?(hash)
    end

    bombs_hash

  end
end
