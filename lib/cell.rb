require 'set'

class Cell
  attr_reader :display, :neighbors, :value, :unknown

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

  def expand
    has_bomb_around = false
    @neighbors.each do |cell|
      has_bomb_around = cell.is_bomb
    end

    if !has_bomb_around
      @neighbors.each do |cell|
        if !cell.is_bomb && !cell.has_flag
          cell.unknown = false
          puts "passou no expand"
          cell.expand
        end
      end
    end
  end

end
