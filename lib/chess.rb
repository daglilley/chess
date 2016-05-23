# Chess

require "pieces"


class Chess
  WHITE = :White
  BLACK = :Black
  EMPTY = :Empty
  attr_reader :player, :board

  def initialize
    @player = WHITE
    @board = Board.new(WHITE, BLACK)
    #play
  end

  def next_player
    @player == WHITE ? @player = BLACK : @player = WHITE
  end

  def play
    @board.display
    until check?
      next_player unless @board.empty?
      take_turn
      @board.display
    end
    check_mate
  end

  def take_turn
    print "Player #{@player}'s move: "
    choice = gets.chomp
    if valid_move?(choice)
      @board.make_move(@player, choice)
    else
      puts "Invalid move. Try again."
      take_turn
    end
  end

  def valid_move?(choice)
    valid = true
    choice = sanitize(choice)
    position = choice[0..1]
    target = choice[2..-1]
    valid = false if !@board.extant_position?(position)
    valid = false if !@board.extant_position?(target)
    # then check if own something in that position
    # then check if valid moves for that unit match
  end

  def sanizite(choice)
    choice.gsub!(/[, ]+/, "")
  end


  def make_move
  end
  def check?
  end
  def check_mate
  end

  #def 
  #end

end



module Positions
  def to_notation(i_col, i_row)
    n_col = col_to_notation(i_col).to_s
    n_row = row_to_notation(i_row).to_s
    notation = "#{n_col}#{n_row}"
  end
  def to_index(n_col, n_row)
    i_col = col_to_index(n_col).to_i
    i_row = row_to_index(n_row).to_i
    index = [i_col, i_row]
  end
  
  def col_to_notation(index)
    alphabet = ("a".."h").to_a
    alphabet[index]
  end
  def col_to_index(notation)
    alphabet = ("a".."h").to_a
    alphabet.index(notation)
  end
  def row_to_notation(index)
    index += 1
  end
  def row_to_index(notation)
    notation -= 1
  end
end



class Board
  WIDTH = 8
  HEIGHT = 8
  attr_reader :width, :height, :squares

  def initialize(white, black)
    @squares = Array.new(WIDTH){ Array.new(HEIGHT) }
    @last_player = nil
    @last_move = nil
    set_board(white, black)
  end

  def set_board(white, black)
    wipe_board
    @squares.each { |col| col[1] = Pawn.new(white) }
    @squares[0][0] = Rook.new(white)
    @squares[1][0] = Knight.new(white)
    @squares[2][0] = Bishop.new(white)
    @squares[3][0] = Queen.new(white)
    @squares[4][0] = King.new(white)
    @squares[5][0] = Bishop.new(white)
    @squares[6][0] = Knight.new(white)
    @squares[7][0] = Rook.new(white)
    @squares.each { |col| col[6] = Pawn.new(black) }
    @squares[0][7] = Rook.new(black)
    @squares[1][7] = Knight.new(black)
    @squares[2][7] = Bishop.new(black)
    @squares[3][7] = Queen.new(black)
    @squares[4][7] = King.new(black)
    @squares[5][7] = Bishop.new(black)
    @squares[6][7] = Knight.new(black)
    @squares[7][7] = Rook.new(black)
  end
  
  def wipe_board
    @squares.map! { |col| col.map! { |row| row = Chess::EMPTY } }
  end

  
  
  def display
    puts ascii_col_labels
    puts ascii_separator
    7.downto(0) do |row|
      puts ascii_row(row)
      puts ascii_separator
    end
    puts ascii_col_labels
  end

  def ascii_separator
    line = "   ---- ---- ---- ---- ---- ---- ---- ----   "
  end
  
  def ascii_row(row)
    line = "#{row_to_notation(row)} |"
    @squares.each do |col|
      col[row] == Chess::EMPTY ? line << "    |" : line << " #{col[row].icon} |"
    end
    line << " #{row_to_notation(row)}"
  end
  
  def ascii_col_labels
    labels = ("a".."h").to_a
    line = "    " << labels.join("    ") << "    "
  end
  
  

  
  def to_notation(index)
    n_col = col_to_notation(index[0])
    n_row = row_to_notation(index[1])
    notation = "#{n_col}#{n_row}"
  end
  def to_index(notation)
    i_col = col_to_index(notation[0])
    i_row = row_to_index(notation[1].to_i)
    index = [i_col, i_row]
  end
  
  def col_to_notation(index)
    alphabet = ("a".."h").to_a
    alphabet[index]
  end
  def col_to_index(notation)
    alphabet = ("a".."h").to_a
    alphabet.index(notation)
  end
  def row_to_notation(index)
    index += 1
  end
  def row_to_index(notation)
    notation -= 1
  end
  
  
  def extant_position?(position)
    exists = true
    exists = false if !col_exists(position[0])
    exists = false if !is_integer?(position[1]) || !row_exists?(position[1])
    exists
  end
  def col_exists?(col)
    cols = ("a".."h").to_a
    cols.include?(char.to_s)
  end
  def is_integer?(char)
    char.to_i == 0 && char != "0" ? false : true
  end
  def row_exists?(row)
    row.between?(0, WIDTH)
  end


end

# Really ought to check if Position is index or Notation too
# Create a Position for each square and use the method there?
# Position.col_to_index(col, row)?
# Yeah, could call Position::row_to_index(row)
# And method could be def row_to_index(row = @row)
# Or maybe there's a module!
# Module is used for position calculations
# That makes much more sense.


# Replay should be outside of Chess class
# So no need for reset?


def replay?
end

def replay
end
