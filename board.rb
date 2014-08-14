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
    generate_starting_tiles(:red,7)
  end
  
  def display_state
    board_state = Array.new(@dim) { Array.new([]) }
    @tiles.each_with_index do |row, index|
      row.each do |piece|
        if piece.nil?
          board_state[index] << "_"
        else
          board_state[index] << piece.to_s
        end
      end
    end
    board_state.each_with_index do |row, rank|
      puts "#{rank} " + row.join
    end
    print "  "
    bottom_row = @dim-1
    (0..(@dim-1)).each do |col|
      print col
    end
    puts "\n"
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

aaa = Board.new(8,3)
# aaa.display_state
aaa.tiles[7][7].maybe_promote
p aaa.tiles[7][7].type
p aaa.tiles[0][2]
aaa.tiles[2][0].color = :black
#aaa.tiles[2][2] = nil
aaa.display_state
# aaa.tiles[2][2].perform_slide([3,3])
# aaa.display_state
aaa.tiles[2][2].perform_slide([3,3])
aaa.display_state
aaa.tiles[3][3].perform_slide([4,2])
aaa.display_state
aaa.tiles[5][1].perform_jump([3,3])
aaa.display_state