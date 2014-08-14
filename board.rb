require './piece.rb'

class Board
  attr_reader :tiles, :dim, :depth
  attr_writer :tiles 
  def initialize(dim, piece_depth)
    @dim = dim
    @piece_depth = piece_depth
    @tiles = Array.new(@dim) { Array.new(@dim, nil) }
    piece_depth.times do |i|
      generate_starting_tiles(:red, i)
      generate_starting_tiles(:black, dim - i - 1)
    end
  end
  
  def [](coordinates)
    @tiles[coordinates.first][coordinates.last]
  end
  
  def generate_starting_tiles(color, rank)
    @dim.times do |i|
      if (rank - i).even?
        #@tiles[rank][i] = Piece.new([2,2], color, self)
        @tiles[rank][i] = Piece.new([rank,i], color, self)
      end
    end
  end
  
end

board = Board.new(8,3)
p board