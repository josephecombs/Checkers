require './board.rb'

class Checkers
  def initialize
    @board = Board.new(8, 3)
  end
  
  def play_game(player1, player2)
    over = false
    players = [player1, player2]
    counter = 0
    until over
      toggle = counter % 2
      @board.display_state
      arg, proposed_moves = players[toggle].get_input
      proposed_color = @board.tiles[proposed_moves.first.first][proposed_moves.first.last].color
      
      proposed_type = @board.tiles[proposed_moves.first.first][proposed_moves.first.last].type
      
      
      #don't let players move pieces that aren't theirs
      if players[toggle].color != proposed_color
        "you can't move your opponent's pieces!"
        next
      end
      
      #has to specifically call this method on the piece the user wants to move
      if @board.tiles[proposed_moves.first.first][proposed_moves.first.last].valid_move_seq?(arg, proposed_moves, proposed_color, proposed_type)
        counter += 1
      else
        next
      end
      
      #make moves if those moves are valid
      
      if @board.tiles.flatten.compact.select { |tile| tile.color == :red } == 0
        puts "Game Over! Black wins!"
        over = true
      elsif @board.tiles.flatten.compact.select { |tile| tile.color == :black } == 0
        puts "Game over! Red wins!"
        over = true
      end
    end
  end
end

class HumanPlayer
  attr_reader :name, :color
  def initialize(name, color)
    @name = name
    @color = color
  end
  
  def get_input
    puts "#{@name}, #{color} player; enter from and to coordinates as 
    origin/(multiple)destination ex: 's,12,34' or 'j,12,34:"
    
    #first char of this string is what user wants to do
    #count on user giving us quality input ;)
    #shift off the argument (jump vs slide)
    dump = gets.chomp.split(',')
    arg = dump.shift
    
    
    coordinates_array = []
    
    dump.each do |pair|
      coordinates_array << [pair[0].to_i, pair[1].to_i]
    end

    [arg, coordinates_array]
  end
end

class ComputerPlayer
  def initialize(color)
    @name = "DraughtsBot32284"
    @color
  end
  
  def get_input
  end
end

b = HumanPlayer.new("Joe", :red)
c = HumanPlayer.new("Kam", :black)

a = Checkers.new
a.play_game(b,c)