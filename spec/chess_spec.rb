# spec/chess_spec.rb
require "chess"

describe Chess do
  let(:c) { Chess.new }
  let(:b) { c.board }
  let(:white) { Chess::WHITE }
  let(:black) { Chess::BLACK }

  # Chess object setup
  
  describe "Chess.new" do
    it "sets player to #{Chess::WHITE}" do
      expect(c.player).to eq(white)
    end
    it "creates a new game board" do
      expect(c.board).to be_instance_of(Board)
    end
  end

  # Board object setup
  
  describe "Board.new" do
    it "creates an 8 x 8 square array" do
      expect(b.squares.length).to eq(8)
      expect(b.squares[0].length).to eq(8)
    end
  end
  
  describe "Board.set_board" do
    it "puts #{Chess::WHITE} pawns in their starting positions" do
      b.reset_board
      expect(b.squares[0][1]).to be_instance_of(Pawn)
      expect(b.squares[0][1].player).to eq(white)
      expect(b.squares[7][1]).to be_instance_of(Pawn)
      expect(b.squares[7][1].player).to eq(white)
    end
    it "puts #{Chess::WHITE} major pieces in their starting positions" do
      b.reset_board
      expect(b.squares[0][0]).to be_instance_of(Rook)
      expect(b.squares[0][0].player).to eq(white)
      expect(b.squares[6][0]).to be_instance_of(Knight)
      expect(b.squares[6][0].player).to eq(white)
    end
  end
  describe "Board.set_board" do
    it "puts #{Chess::BLACK} pawns in their starting positions" do
      b.reset_board
      expect(b.squares[0][6]).to be_instance_of(Pawn)
      expect(b.squares[0][6].player).to eq(black)
      expect(b.squares[7][6]).to be_instance_of(Pawn)
      expect(b.squares[7][6].player).to eq(black)
    end
    it "puts #{Chess::BLACK} major pieces in their starting positions" do
      b.reset_board
      expect(b.squares[1][7]).to be_instance_of(Knight)
      expect(b.squares[1][7].player).to eq(black)
      expect(b.squares[5][7]).to be_instance_of(Bishop)
      expect(b.squares[5][7].player).to eq(black)
    end
  end
  
  # Overhead game management
  
  describe "Chess.next_player" do
    it "changes from #{Chess::WHITE} player to #{Chess::BLACK} player" do
      c.next_player
      expect(c.player).to eq(black)
    end
    it "changes from #{Chess::BLACK} player to #{Chess::WHITE} player" do
      2.times { c.next_player }
      expect(c.player).to eq(white)
    end
  end

  # Move interpretation
  
  describe "Position.valid?" do
    it "validates legal board positions" do
      expect(Position::valid?("a3")).to eq(true)
    end
    it "invalidates illegal board positions" do
      expect(Position::valid?("p3")).to eq(false)
    end
    it "invalidates nonconforming board positions" do
      expect(Position::valid?("ap")).to eq(false)
    end
  end

  describe "Move.valid?" do
    it "validates A#A# formatting" do
      expect(Move::valid?("e4g5")).to eq(true)
    end
    it "validates A# A# formatting" do
      expect(Move::valid?("e4 g5")).to eq(true)
    end
    it "validates A#,A# formatting" do
      expect(Move::valid?("e4,g5")).to eq(true)
      expect(Move::valid?("e4, g5")).to eq(true)
    end
  end
  
  # Move interpretation
  
  describe "Move.start" do
    it "gets a move's start position" do
      move = Move.new("e4, g5")
      expect(move.start).to eq("e4")
    end
  end
  describe "Move.target" do
    it "gets a move's end position" do
      move = Move.new("e4, g5")
      expect(move.target).to eq("g5")
    end
  end
  
  # Notation translation
  
  describe "Position::row_to_notation" do
    it "converts a row array index to notation" do
      expect(Position::row_to_notation(3)).to eq("4")
    end
  end
  describe "Position::row_to_index" do
    it "converts row notation to an array index" do
      expect(Position::row_to_index(3)).to eq(2)
    end
  end
  describe "Position::col_to_notation" do
    it "converts a column array index to notation" do
      expect(Position::col_to_notation(6)).to eq("g")
    end
  end
  describe "Position::col_to_index" do
    it "converts column notation to an array index" do
      expect(Position::col_to_index("e")).to eq(4)
    end
  end
  describe "Position::to_notation" do
    it "converts a square array index to notation" do
      expect(Position::to_notation([2, 3])).to eq("c4")
    end
  end
  describe "Position::to_index" do
    it "converts Chess notation to array indices" do
      expect(Position::to_index("h7")).to eq([7, 6])
    end
  end
  
  describe "Position.new" do
    it "creates an index position from notation input" do
      pos = Position.new("e4")
      expect(pos.col).to eq(4)
      expect(pos.row).to eq(3)
      expect(pos.index).to eq([4, 3])
    end
  end
  
  # Piece representation
  
  describe "Pawn.icon" do
    it "gets the symbol for #{Chess::WHITE} Pawns" do
      b.set_board(white, black)
      expect(b.squares[0][1].icon).to eq("P")
    end
    it "gets the symbol for #{Chess::BLACK} Pawns" do
      b.set_board(white, black)
      expect(b.squares[0][6].icon).to eq("p")
    end
  end
  
  # Board representation
  
  describe "Board.ascii_separator" do
    it "writes a horizontal row separating line" do
      expect(b.ascii_separator).to eq("   --- --- --- --- --- --- --- ---   ")
    end
  end
  describe "Board.ascii_row" do
    it "writes a horizontal row without pieces" do
      b.set_board(white, black)
      expect(b.ascii_row(5)).to eq("6 |   |   |   |   |   |   |   |   | 6")
    end
  end
  describe "Board.ascii_row" do
    it "writes a horizontal row with a piece" do
      b.set_board(white, black)
      b.squares[3][3] = Pawn.new(white)
      expect(b.ascii_row(3)).to eq("4 |   |   |   | P |   |   |   |   | 4")
    end
    it "writes a horizontal row with pieces" do
      b.set_board(white, black)
      expect(b.ascii_row(7)).to eq("8 | r | n | b | k | q | b | n | r | 8")
      puts b.ascii_separator
      puts b.ascii_row(7)
      puts b.ascii_col_labels
    end
  end
  describe "Board.ascii_col_labels" do
    it "writes a horizontal listing of alphabetical column labels" do
      b.set_board(white, black)
      expect(b.ascii_col_labels).to eq("    a   b   c   d   e   f   g   h    ")
    end
  end
  
  # Piece move checking
  
  describe "Pawn.valid_moves(position)" do
    it "says one position forward is a valid move" do
      start = Position.new("d3")
      target = Position.new("d4")
      pawn = Pawn.new(white)
      valid_moves = pawn.valid_moves(b, start)  # Pawn must take board and position
      expect(valid_moves.include?(target)).to eq(true)
    end
    it "says one taken position forward isn't a valid move" do
    end
    it "says two positions forward is a valid first move" do
      ### IF is currently placed in starting row, so no need for first move flag
    end
    it "says two positions forward isn't a valid move post-first move" do
    end
    it "says one enemy taken position diagonally is a valid attack" do
    end
    it "recognizes en passant as a valid attack" do
    end
  end
  
=begin
  Put in "e4g5"
  Says start is "e4"
  Says target is "g5" >> target = Position.new(move.target) (so is Position)
  Checks ownership of Position >> Board.checkPiece
  Checks moves for Position >> Board.piece
  Sees if movelist includes Position (all done in index)
  
  "e4" and "g5" are strings as that's easier to deal with
  Positions are with indexes
=end
  
  # Pass Positions back and forth? -------------
  
  # Move = gets.chomp
  # Check formatting (letter, number, letter, number)
  # >> Comment that it isn't flexible but could be with (letters, numbers...)
  # Start = Move.start
  # Target = Move.target
  # Convert both to index
  # Check if they are valid
  
  # Board interpretation procedures
  
end

=begin
# Change to symbols and upper/lower for white/black
Makes Chess
Makes Board
Makes Player white
Makes Player black
Can change player
Sets Board dimensions
Puts Pieces on Board
Can write Separators
Can write Pieces
Can write blank squares
Can write column labels
Convert Notation to Index
Convert Index to Notation
-- row, column, both, or x 2 (move) [just do the math, regardless of validity]
Movement;
# How to see moves, vs attack moves, vs special moves?
validate both positions, then--
ask: valid_move? (must pass board so can see pieces in the way)
ask: valid_attack? (often the same as valid_move?)
-- then check special? en passant, castle, etc
-- check if promotion
-- check if put king in check
=end



=begin

  end
  
  describe "Pawn.valid_moves(position)" do
    it "says one position forward is a valid move" do
    end
    it "says one taken position forward isn't a valid move" do
    end
    it "says two positions forward is a valid first move" do
    end
    it "says two positions forward isn't a valid move post-first move" do
    end
    it "says one enemy taken position diagonally is a valid attack" do
    end
    it "recognizes en passant as a valid attack" do
    end
  end
  
  
  # How determine check mate
  # Just check every single possible next move?
  
  # isInCheck [is King's underAttack?] // isUnderAttack
  # underAttackBy(given)
  # underAttack
  # canAttack(given)
  
  # Generate list of possible moves (ignore if puts that side in check)
  # For each move, check it doesn't leave the side in check
  # If every move leaves King in check, then mated or stalemated
  # Mate if side to move is in check. Otherwise, stalemate
  
  # Symbols can be handled by Board when printing, ONLY
  
  # Board has cells with pieces in them.
  # Easily see if piece in a spot, and who owns it, when moving.
  # And see if it's a King
  
  # Ought to convert chess notation to array indexes
  
  describe "Pawn.valid_move?" do
    # first move
    # non-first move
    # piece in way
    # attackable enemy
    # ally in that spot
    # top of board?
  end
  
end
# class Chess
# class Board
# class Piece
# -- Pawn
#      Owner
#      Rules
#      > Has moved? (Pawn, Rook, King)
# -- Rook
# -- Knight
# -- Bishop
# -- Queen
# -- King
# Match
# Board --positions
# ~Players
# Pieces
  # Owner
  # Type --rules
  # Special Data (pawn first move?)
# Make board
## check_mate check would check beginning of the turn, if there are any legal moves which allow escape from check? So if check, then checks?
  
  
  
  
=end
  
  
  
  
