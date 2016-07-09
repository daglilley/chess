require_relative "chessboard"
require_relative "pieces"
require_relative "positions"


class Chess
  PLAYERS = [:white, :black]
  COMMANDS = [:save, :load, :quit, :draw]
  
  def initialize
    @board = Chessboard.new
    @last_player = :black
    @player = :white
    #start_match
  end
  
  def start_match
    play
  end
  
  private

  # This method is unwieldy and should be rewritten if refactoring.
  def play
    print_board
    game_set = false
    until game_set
      outcome = try_turn
      case outcome
      when :do_load, :do_quit, :do_draw
        game_set = outcome
      when :do_save
        do_save
      when :moved
        next_player
        print_board
        game_set = :checkmate if checkmate? unless game_set
        game_set = :stalemate if stalemate? unless game_set
        game_set = claim_draw(:fifty) if fifty_moves?
        game_set = :do_draw if insufficient_material?
        game_set = claim_draw(:threefold) if threefold?
      when :unknown
        report(:unknown)
      when :rejected
      else
        puts "Error! An unknown error has occured."
        print_board
      end
      if !game_set && fiftymove? && verify_draw(:fiftymove) == :verified then game_set = :do_draw end
      #if !game_set && threefold? && verify_draw(:threefold) == :verified then game_set = :do_draw end
    end
    handle_game_set(game_set)
  end
  
  def next_player
    @last_player = @player
    i = PLAYERS.find_index(@player)
    @player = if i.nil? then PLAYERS[0]
    elsif i == PLAYERS.length - 1 then PLAYERS[0]
    else PLAYERS[i + 1] end
  end
  
  def try_turn
    puts
    print "Player #{@player.to_s.capitalize}'s command: "
    input = gets.chomp
    outcome = classify_input(input)
    outcome = handle_command(input) if outcome == :command
    outcome = handle_move(input) if outcome == :move
    outcome
  end

  def classify_input(input)
    outcome = :command if is_raw_command?(input)
    outcome ||= :move if is_raw_move?(input)
    outcome ||= :unknown
  end
  
  def handle_command(input)
    outcome = try_command(input)
    outcome
  end
  
  def handle_move(input)
    outcome = try_move(input)
    outcome = :moved if outcome == :success
    outcome
  end
  
  def try_command(input)
    case input.downcase.to_sym
    when :save
      outcome = verify_save
      outcome = :do_save if outcome == :verified
    when :load
      outcome = verify_load
      outcome = :do_load if outcome == :verified
    when :quit
      outcome = :do_quit
    when :draw
      outcome = verify_draw
      outcome = :do_draw if outcome == :verified
    end
    if outcome == :failed || outcome == :unknown
      report(outcome)
      outcome = :rejected
    end
    outcome
  end
  
  def try_move(input)
    case @board.verify_move(Move.new(input), @player)
    when :verified
      do_move(Move.new(input))
      outcome = :success
    when :empty, :blocked, :occupied, :illegal
      report(:illegal)
    when :besieged
      report(:besieged)
    when :exposed
      report(:exposed)
    else
      report(:unknown)
    end
    outcome = :rejected unless outcome == :success
    outcome
  end
  
  def do_move(move)
    @board.do_move(move)
    do_promotion(move) if @board.promote?(move)
  end
  
  def do_promotion(move)
    print "Promote to what piece?: "
    input = gets.chomp.downcase.to_sym
    case input
    when :rook, :r
      @board.do_promotion(move, :rook)
    when :knight, :n
      @board.do_promotion(move, :knight)
    when :bishop, :b
      @board.do_promotion(move, :bishop)
    when :queen, :q
      @board.do_promotion(move, :queen)
    when :pawn, :p, :king, :k
      report(:illegal_promotion)
      do_promotion(move)
    else
      report(:unknown_promotion)
      do_promotion(move)
    end
  end
  
  def verify_save
    #don't report anything
    #outcome = :verified, :failed
  end
  
  def verify_load
    #don't report anything
    #outcome = :verified, :failed
  end
  
  def verify_draw(type = :none)
    #don't report anything
    #outcome = :verified, :failed
    outcome = :failed
  end
  
  def do_save
    report(:saved)
    #no return value
  end
  
  def do_load
    report(:loaded)
    #no return value
  end
  
  # Unable to check if a castle could escape check... because illegal anyways
  def checkmate?
    checkmate = @board.checkmate?(@player)
  end
  
  def stalemate?
    @board.stalemate?(@player)
  end
  
################
  def claim_draw(reason)
    puts
    puts case reason
    when :fifty
      "Fifty or more moves taken with neither a capture nor a pawn movement."
    when :threefold
      "Threefold repetition."
    end
    consent = verify_draw_ask(@player)
    verify = if consent then :do_draw else nil end
  end
  
  def verify_draw_ask(player)
    print "Player #{@player}, do you accept a draw? (y/n): "
    input = gets.chomp
    if input.downcase == "y"
      consent = true
    elsif input.downcase == "n"
      consent = false
    else
      report(:unknoqn)
      consent = verify_draw_ask(player)
    end
    consent
  end
  
################
  def fifty_moves?
    @board.fifty_move?
  end
  
################
  def threefold?
    return false
  end
  
  def insufficient_material?(player)
    insufficient = @board.insufficient_material?(player)
    puts "Insufficient material to checkmate."
    insufficient
  end
  
  def handle_game_set(exit)
    case exit
    when :loaded
    when :quit
    when :draw
    when :checkmate
      puts "\nCheckmate! Player #{@last_player.to_s.capitalize} is victorious!"
    when :stalemate
    end
  end

  def print_board
    puts
    @board.print_board
  end  
  
  def report(type)
    case type
    when :illegal
      puts "Rejected! Move is illegal."
    when :beseiged
      puts "Rejected! King cannot move through squares in check."
    when :exposed
      puts "Rejected! Move puts you in check."
    when :unknown
      puts "Error! Command not recognized."
    when :success
      puts "Success!"
    when :failed
      puts "Error! Command failed."
    when :illegal_promotion
      puts "Rejected! Cannot promote to that piece."
    when :unknown_promotion
      puts "Error! Piece not recognized."
    end
  end

  def is_raw_command?(input)
    input.downcase!
    valid = COMMANDS.include?(input.to_sym)
  end
  
  # Mirrored (as a process) by #normalization in Move.
  def is_raw_move?(input)
    move = input.downcase.gsub(/[, ]+/, "")
    valid = move.length == 4
    if valid
      origin, destination = move[0..1], move[2..3]
      valid = false if !is_raw_position?(origin)
      valid = false if !is_raw_position?(destination)
    end
    valid
  end

  def is_raw_position?(pos)
    file, rank = pos[0], pos[1]
    files = ("a".."z").to_a.take(Chessboard::WIDTH)
    ranks = ("1"..Chessboard::HEIGHT.to_s).to_a
    valid = files.include?(file)
    valid ||= ranks.include?(rank) if valid
    valid
  end

end


# Program start
#chess_game = Chess.new
#chess_game.start_match

