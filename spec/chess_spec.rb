# spec/chess_spec.rb
require "chess"

describe Position do
end

describe Move do
end

describe Square do
end

describe Pawn do
end

describe Rook do
end

describe Knight do
end

describe Bishop do
end

describe Queen do
end

describe King do
end

describe Chessboard do
  let(:b) { Chessboard.new }
  
  describe "Chessboard.do_move" do
    context "Black tries to take a piece" do
      it "moves black's piece and removes the piece it captures" do
        b.do_move("b2b4")
        b.do_move("b7b6")
        b.do_move("b4b5")
        b.do_move("a7a5")
        b.do_move("b5a6")
        b.do_move("a8a6")
      end
    end
  end
  
  describe "Chessboard.checkmate?" do
    context "Black puts White into checkmate" do
      it "ends the game" do
        b.do_move("f2f3")
        b.do_move("e7e5")
        b.do_move("g2g4")
        b.do_move("d8h4")
        b.in_check?(:white).to eq(true)
        b.checkmate?(:white).to eq(true)
      end
    end
  end
  
end

#describe Chess do
#  let(:c) { Chess.new }
#end

