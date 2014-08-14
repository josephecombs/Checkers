require './board.rb'

class Checkers
  def initialize
    @board = Board.new(8, 3)
  end
  
  def play_game(player1, player2)
    over = false
    until over
      puts "playing game"
      
      
    end
  end
end



class HumanPlayer
  attr_reader :name
  def initialize(name)
    @name = name
  end
  
  def get_input
  end
end

class ComputerPlayer
  def initialize
  end
  
  def get_input
  end
end