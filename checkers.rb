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
      puts "playing game"
      args = players[toggle].get_input
      p args
      counter += 1
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
    puts "#{@name}, enter from and to coordinates as origin/(multiple)destination ex: '[1,2]|[2,1]':"
    input = gets.chomp.split('|')
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