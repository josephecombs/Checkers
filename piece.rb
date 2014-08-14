class Piece
  attr_reader :coordinates, :type, :color, :board
  
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
  
  def perform_slide(pos1, pos2)
    move_diffs.map {|diff| diff + @coordinates }
    if move_diffs.include?(pos2)
      #change the board
      @board.tiles[]
      
      #try to promote the piece you've moved
      maybe_promote(pos2)
      true      
    else
      false
    end
  end
  
  def perform_jump(pos1, pos2)
    doubled_diffs = move_diffs.map { |diff| diff * 2 }
    doubled_diffs.map {|diff| diff + @coordinates }
    if doubled_diffs.include(pos2)
      #change the board
      maybe_promote(pos2)
      true
    else
      false
    end
  end
  
  def move_diffs
    if @type == man
      if @color == :black
        [[-1,-1],[1,-1]]
      else
        [[-1,1],[1,1]]
      end
    elsif type == :king
      [[-1,-1],[1,-1],[-1,1],[1,1]]
    end
  end
  
  def maybe_promote(pos)
    if pos[0] == 7 && @color == :red
      type == :king
    elsif pos[0] == 0 && @color == :black
      type == :king
    end
  end
end