class Piece
  attr_reader :type, :board
  attr_accessor :color, :coordinates 
  
  def initialize(coordinates, color, board)
    @coordinates = coordinates
    @type = :king
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
  
  def valid_slides
    absolute_positions = move_diffs.map do |diff| 
      [diff.last + @coordinates.last, diff.first + @coordinates.first]
    end
    
    absolute_positions.select do |position|
      inside_bounds?(position) && @board[position].nil?
    end
  end
  
  def valid_jumps
    if type == :man
      absolute_positions = double_elements(move_diffs).map do |diff| 
        #don't even try to read this.  just have faith that it works.
        [diff.first + @coordinates.last, diff.last + @coordinates.first]
      end
    elsif type == :king
      p "inside king's valid jumps"
      absolute_positions = double_elements(move_diffs).map do |diff|
        #don't even try to read this.  just have faith that it works.
        [diff.first + @coordinates.last, diff.last + @coordinates.first]
      end
      # absolute_positions = []
      # absolute_positions << []
      
      p "absolute_positions = #{absolute_positions}"
    end
    
    
    absolute_positions.select do |pos2|
      jumped = [
        (@coordinates.first + pos2.first) / 2, 
        (@coordinates.last + pos2.last) / 2
      ]

      next unless inside_bounds?(pos2) && !@board[jumped].nil?
      occupied_by_enemy = @board[jumped].color != @color
      occupied_by_enemy && @board[pos2].nil?
    end
  end
  
  def move_piece!(pos2)
    @board[pos2] = self
    @board[@coordinates] = nil
    @coordinates = pos2
  end
  
  def perform_slide(pos2)
    if valid_slides.include?(pos2)
      move_piece!(pos2)
      true
    else
      false
    end
  end
  
  def perform_jump(pos2)
    if valid_jumps.include?(pos2)
      jumped_tile_to_nil = [
        (@coordinates.first + pos2.first)/2, 
        (@coordinates.last + pos2.last)/2
      ]
      #this must be done after calculating jumped_tile_to_nil because move_piece mutates coordinates
      move_piece!(pos2)
      @board.display_state
      @board[jumped_tile_to_nil] = nil
      @board.display_state
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
    elsif @type == :king
      p "generating king's move diffs"
      [[-1,-1],[1,-1],[-1,1],[1,1]]
    end
  end
  
  def double_elements(arr)
    p "doubling elements"
    doubled_array = []
    arr.each do |coord|
      doubled_array << [(coord[0] * 2), (coord[1] * 2)]
    end
    p "doubled_array = #{doubled_array}"
    doubled_array
  end
  
  def maybe_promote
    if @coordinates.first == 7 && @color == :red
      @type = :king
      return true 
    elsif @coordinates.first == 0 && @color == :black
      @type = :king
      return true
    end
    false
  end
  
  def inside_bounds?(coords)
    coords.all?{ |coord| coord.between?(0, @board.dim - 1) }
  end
end