class Chessboard
  HEIGHT, WIDTH = 8, 8
  CHARACTERS = [:pawn, :rook, :knight, :bishop, :queen, :king] \
               ["P",   "R",   "N",     "B",     "Q",    "K"]   \
               ["p",   "r",   "n",     "b",     "q",    "k"]
  
  def initialize
    @pieces = (make_white_pieces << make_black_pieces).flatten
    make_tracking_variables
  end
  
  def print_board
    board = make_model
    (HEIGHT).downto(1) { |rank| print_rank(board[rank], rank) }
    puts
    print_files
  end
  
  def verify_move(move, board = make_model(move))
    origin, destination = move.positions
    piece = get_piece(origin)
    outcome = verify_piece(piece)
    outcome = verify_move(move) if outcome == :verified
    if outcome == :illegal
      outcome = verify_en_passant(move) if piece.type == :pawn
      outcome = verify_rook_castle(move) if piece.type == :rook
      outcome = verify_king_castle(move) if piece.type == :king
    end
    if outcome == :verified
      outcome = :exposed if in_check?(@player, make_projection_model(move))
    end
    outcome
  end
  
  private
  
  ##### These go further done once written
  
  def verify_piece(piece)
    outcome = :empty if piece.type == :none
    outcome ||= :occupied if piece.player != @player
    outcome ||= :verified
    outcome
  end
  
  def verify_move(move)
    origin, destination = move.positions
    outcome = :blocked if get_piece(destination).player == @player
    outcome ||= :illegal if !get_piece(origin).get_moves(make_model)
    outcome ||= :verified
    #outcome
  end
  
  def verify_en_passant(move)
    origin, destination = move.positions
    outcome = :verified if destination.notation == en_passant_destination && \
                           get_piece(origin).can_en_passant?(make_model, @en_passant_destination)
    outcome ||= :illegal
    #outcome
  end
  
  ####### Castle checks should internally perform check tests for empty intermediate squares ########
  # Also need to make sure checks if rook and castle have before moved
  def verify_rook_castle(move)
    outcome = :verified
    outcome ||= :sieged_castle
    #outcome
  end
  
  def verify_king_castle(move)
    outcome = :verified
    outcome ||= :sieged_castle
    #outcome
  end
    
  
  ########################################
  
  def make_tracking_variables
    @en_passant_destination = :none
    @en_passant_capture = :none
    @unmoved_piece_positions = []
    @pieces.each { |piece| @unmoved_piece_positions << piece.pos }
  end
  
  def make_white_pieces
    pieces = []
    pieces << make_pawns_at(:white, 1)
    pieces << make_capitals_at(:white, 0)
    pieces
  end
    
  def make_black_pieces
    pieces = []
    pieces << make_pawns_at(:black, HEIGHT - 2)
    pieces << make_capitals_at(:black, HEIGHT - 1)
    pieces
  end
  
  def make_pawns_at(player, rank)
    pawns = []
    WIDTH.times_with_index { |i| pawns << Pawn.new(player, [i, rank]) }
    pawns
  end
  
  def make_capitals_at(player, rank)
    pieces = []
    pieces << Rook.new(player, [0, rank])
    pieces << Rook.new(player, [7, rank])
    pieces << Knight.new(player, [1, rank])
    pieces << Knight.new(player, [6, rank])
    pieces << Bishop.new(player, [2, rank])
    pieces << Bishop.new(player, [5, rank])
    pieces << Queen.new(player, [3, rank])
    pieces << King.new(player, [4, rank])
    pieces
  end
  
  ##################
  
  # ALL MOVEMENT CHECKING AND TESTING MUST USE THIS
  # THIS WAY EVERYTHING IS COMPATIBLE WITH CHECK PREDICTIONS
  def make_model
    board = Array.new(WIDTH){ Array.new(HEIGHT, Square.new) }
    @pieces.each do |piece|
      file, rank = piece.pos.index
      board[file][rank] = Square.new(piece.player, piece.type)
    end
    board
  end
  
  def make_projection_model(move)
    model = make_model
    o_file, o_rank = move.origin.index
    d_file, d_rank = move.destination.index
    board[d_file][d_rank] = board[o_file][o_rank]
    board[o_file][o_rank] = Square.new
    model
  end
  
  def print_rank(squares, rank)
    string = "#{rank}"
    rank >= 10 ? string += " " : string += "  "
    squares.each { |square| string += "[#{get_character_for(square)}]" }
    puts string
  end
  
  def print_files
    files = ("A".."Z").to_a.take(WIDTH)
    string = "   "
    files.each { |file| string += " #{file} " }
    puts string
  end
  
  def get_character_for(square)
    index = CHARACTERS[0].index(square.type)
    if index
      character = playerize_character(square.player, index)
    else
      character = " "
    end
    character
  end
  
  def playerize_character(player, index)
    list = 1 if player = :white
    list = 2 if player = :white
    character = CHARACTERS[list][index]
  end
  
  def in_check?(player, board)
    king_pos = Position.new
    board.each_with_index do |rank, i|
      rank.each_with_index do |square, j|
        king_pos = Position.new([i][j]) if square.player == player && square.type == :king }
      end
    end
    check = under_attack?(player, board, king_pos)
  end
  
  def under_attack?(player, board, pos)
    captures = []
    
    # need a good method for figuring out moves and captures from this board/square thing
    
    #pieces = compile_pieces
    # then get all captures and compare to pos
  end
  
  def get_piece(pos)
    piece = Piece.new
    @pieces.each { |p| piece = p if p.pos.notation = pos.notation }
    piece
  end
  
  def get_piece_index(pos)
    index = nil
    @pieces.each_with_index { |piece, i| index = i if piece.pos.notation == pos.notation }
    index
  end
  
  def compile_pieces(board)
    
  end

  def remove_piece(pos)
    piece = get_piece(pos)
    @pieces.delete_at(get_piece_index(pos))
  end
  
  # Alises #remove_pos unless a distinction need be made
  def kill_piece(pos)
    remove_piece(pos)
  end
  

  
  
  
  
end