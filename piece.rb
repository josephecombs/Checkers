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
      absolute_positions = double_elements(move_diffs).map do |diff|
        #don't even try to read this.  just have faith that it works.
        [diff.first + @coordinates.last, diff.last + @coordinates.first]
      end
      # absolute_positions = []
      # absolute_positions << []
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
  

  
  def perform_moves(arg, proposed_moves, master_input_color, master_input_type, board)
    start_position = proposed_moves.first
    
    another_dup = board
    if arg == "s" #slide case
      puts "got in on the slide arg"
      puts "args"
      p arg
      p proposed_moves
      p master_input_color
      p master_input_type
      puts "temp board before slide:"
      another_dup.display_state
      another_dup.tiles[start_position.first][start_position.last].perform_slide(proposed_moves[1])
      puts "temp board after slide:"
      another_dup.display_state
      gets.chomp
      return perform_slide(proposed_moves[1])
      # puts board.display_state
      # puts @board.display_state
    else #jumps or many jumps case
      #shift off the first element as a piece cant move to its own square
      proposed_moves.shift
      puts "got in on the jump arg"
      while proposed_moves.count >= 1
        if !perform_jump(proposed_moves[0])
          return false
        end
        proposed_moves.shift
      end
    end
    return true  
  end
  
  def perform_moves!(arg, proposed_moves, master_input_color, master_input_type, board)
    
  end
  
  def valid_move_seq?(arg, proposed_moves, master_input_color, master_input_type)
    arg = arg
    proposed_moves = proposed_moves
    master_input_color = master_input_color
    master_input_type = master_input_type
    
    test_board = @board.dup
    puts "heres test board in the valid_moves_method"
    test_board.display_state
    
    if proposed_moves.count < 2
      puts "invalid number of proposed moves"
      return false
    end
    
    perform_moves(arg, proposed_moves, master_input_color, master_input_type, test_board)
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