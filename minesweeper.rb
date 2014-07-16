require "./board"

class Minesweeper
  
  def initialize(dimension = 9)
    @board = Board.new(dimension)
  end
  
  def play
    
    until over?
      @board.display
      input = get_user_input
      coords = input.first
      flag = input.last
      
      if flag == "-c"
        click_tile(coords.first, coords.last)
      elsif flag == "-f"
        flag_tile(coords.first, coords.last)
      end
    end
    
    @board.display(show_bombs = true)
  end
  
  def get_user_input
    puts "Type in the coordinates of a tile separated by a comma (row, col)," + 
         " followed by -c for click or -f for flag (ex: 7,2 -c):"
    input = gets.chomp.split(" ")
    input[0] = input[0].split(",").map(&:to_i)
    input
  end
  
  def click_tile(row, col)
    @board.reveal_tile(row, col)
  end
  
  def flag_tile(row, col)
    @board.toggle_tile_flag(row, col)
  end
  
  def over?
    return true if @board.exploded? || @board.won?
  end
  
end

Minesweeper.new.play



