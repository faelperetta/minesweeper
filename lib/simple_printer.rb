class SimplePrinter

  def print(board)
    board.each do |line_value|
      line_output = ""
      line_value.each do |column_value|
        line_output += column_value + " "
      end
      puts line_output
    end
  end

end
