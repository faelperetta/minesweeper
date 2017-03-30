require 'set'

# This class represents a cell of an minesweeper board
class Cell

  attr_reader :display, :neighbors, :unknown
  attr_accessor :value


  def initialize(value = '-')
    @unknown = true
    @value = value
    @display = "O"
    @neighbors = Set.new
  end

  def click
    if @unknown == false or @display == "F"
      false
    else
      open
      true
    end
  end


  # This method marks the cell as known
  def open
    @unknown = false
  end

  def is_bomb
    @value == "*"
  end

  def flag
    if !@unknown
      return false
    end

    if @unknown && @display == "F"
      @display = "O"
    else
      @display = "F"
    end

    true
  end

  def has_flag
    @display == "F"
  end

  def add_neighbor(cell_neighbor)
    @neighbors.add(cell_neighbor)
  end

  def to_s
    @unknown ? @display : @value
  end

end
