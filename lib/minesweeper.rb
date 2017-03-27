require File.expand_path('lib/cell.rb')

class Minesweeper
  attr_reader :stil_playing, :victory, :board

  def initialize(width, height, num_mines)
    @width = width
    @height = height
    @num_mines = num_mines
    @victory = false
    @stil_playing = true
    @available_plays = (width * height) - num_mines

    build_board
    generate_bombs
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
      #puts "decrement #{line},#{column}"
      expand column, line

      if (@available_plays == 0)
        #puts "JOGADAS RESTANTES = #{@available_plays}"
        @victory = true
        @stil_playing = false
      end
    end
    valid
  end

  def expand(column, line)
    bombs_around = @board[line][column].neighbors.select do |item|
      pos = item.split(',').collect { |e| e.to_i  }
      @board[pos[0]][pos[1]].is_bomb
    end

    if bombs_around.size == 0
      @board[line][column].neighbors.each do |position|
        l, c = position.split ','
        l = l.to_i
        c = c.to_i

        if !@board[l][c].is_bomb && !@board[l][c].has_flag && @board[l][c].unknown
          @board[l][c].open
          @available_plays -= 1
          #puts "decrement expand #{l},#{c}"
          expand(l,c)
        end
      end
    end
  end

  def board_state(show_values = false)
    num_of_lines = @height - 1
    num_of_columns = @width - 1

    output = ""
    for line in (0..num_of_lines)
      for column in (0..num_of_columns)
        if show_values
          output += @board[line][column].value + " "
        else
          output += @board[line][column].to_s + " "
        end
      end
      puts output
      output = ""
    end

    puts "\n"
  end

  private

  def build_board
    @board = []

    bombs = generate_bombs

    num_of_lines = @height - 1
    num_of_columns = @width - 1

    for line in (0..num_of_lines)
      @board[line] = []
      for column in (0..num_of_columns)
        hash = "#{line}-#{column}"
        cell = bombs.key?(hash) ? bombs[hash] : Cell.new
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

  def generate_bombs
    bombs = {}

    while(bombs.size < @num_mines)
      line = rand(@height)
      column = rand(@width)

      hash = "#{line}-#{column}"
      bombs[hash] = Cell.new "*" if not bombs.key?(hash)
    end

    bombs

  end
end
