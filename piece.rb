class Piece
  attr_reader :type, :board
  attr_accessor :color, :coordinates 
  
  def initialize(coordinates, color, board)
    @coordinates = coordinates
    @type = :man
    @color = color
    @board = board
  end
  
  def to_s
    if @color == :red
      if @type == :man
        return "r"
      else
        return "R"
      end      
    else
      if @type == :man
        return "b"
      else
        return "B"
      end
    end
  end
  
  def perform_slide(pos2)
    absolute_move_diffs = []
    move_diffs.each do |diff| 
      absolute_move_diffs << [diff.last + @coordinates.last, diff.first + @coordinates.first]
    end
    
    
    if inside_bounds?(pos2)
      # p "made it inside bounds check"
      # p absolute_move_diffs
      # p move_diffs
      # p pos2.first, pos2.last
      # p self
      # p "if this is blank it can be moved to:___#{@board.tiles[pos2.first][pos2.last]}___"
      if absolute_move_diffs.include?(pos2) && @board.tiles[pos2.first][pos2.last] == nil
        #change the board
        # puts "made it in"
        # @board.tiles[]
        tile_to_nil = @coordinates
        @board.tiles[pos2.first][pos2.last] = self.dup
        @board.tiles[pos2.first][pos2.last].coordinates = pos2
        @board.tiles[tile_to_nil.first][tile_to_nil.last] = nil
        # @board.tiles[pos1[0]][pos1[1]] = nil
        # @board.tiles[pos2[0]][pos2[1]].coordinates = pos2
        
        #try to promote the piece you've moved
        # maybe_promote
        true      
      else
        false
      end
    end
  end
  
  def perform_jump(pos2)
    doubled_diffs = double_elements(move_diffs)
    
    absolute_move_diffs = []
    doubled_diffs.each do |diff| 
      #don't even try to read this.  just have faith that it works.
      absolute_move_diffs << [diff.first + @coordinates.last, diff.last + @coordinates.first]
    end
    
    p "relative doubled diffs: #{doubled_diffs}"
    
    p "absolute_doubled_diffs: #{absolute_move_diffs}"
    p coordinates
    # doubled_diffs = move_diffs.map { |diff| diff.map{|point| point * 2} }
    # p doubled_diffs
    # doubled_diffs.map! {|diff| diff + @coordinates }
    midpoint_coord = [(pos2.first)]
    
    if absolute_move_diffs.include?(pos2) && @board.tiles[pos2.first][pos2.last] == nil
      p "made it in to second level for jump"
      #change the board for the moving piece
      
      #nuke the jumped piece
      
      jumped_tile_to_nil = [(@coordinates.first + pos2.first)/2, (@coordinates.last + pos2.last)/2]
      p "jumped_tile_to_nil #{jumped_tile_to_nil}"
      tile_to_nil = @coordinates
      @board.tiles[pos2.first][pos2.last] = self.dup
      @board.tiles[pos2.first][pos2.last].coordinates = pos2
      @board.tiles[tile_to_nil.first][tile_to_nil.last] = nil
      @board.tiles[jumped_tile_to_nil.first][jumped_tile_to_nil.last] = nil
      
      #nuke the jumped piece
      
      #maybe_promote(pos2)
      true
    else
      false
    end
  end
  
  def move_diffs
    if @type == :man
      if @color == :black
        [[-1,-1],[1,-1]]
      else
        [[-1,1],[1,1]]
      end
    elsif type == :king
      [[-1,-1],[1,-1],[-1,1],[1,1]]
    end
  end
  
  def double_elements(arr)
    doubled_array = []
    arr.each do |coord|
      doubled_array << [(coord[0] * 2), (coord[1] * 2)]
    end
    doubled_array
  end
  
  def maybe_promote
    # if pos[0] == 7 && @color == :red
    #   @board.tiles[pos].type = :king
    # elsif pos[0] == 0 && @color == :black
    #   @board.tiles[pos].type = :king
    # end
    if @coordinates.first == 7 && @color == :red
      @type = :king
      return true 
    elsif @coordinates.first == 0 && @color == :black
      @type = :king
      return true
    end
    false
  end
  
  def inside_bounds?(coord)
    coord.first.between?(0, @board.dim - 1) && coord.last.between?(0, @board.dim - 1)
  end
end