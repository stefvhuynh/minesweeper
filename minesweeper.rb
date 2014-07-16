require "./board"
require "yaml"

class Minesweeper

  def initialize(dimension = 9)
    @board = Board.new(dimension)
  end

  def play

    until over?
      @board.display
      input = get_user_input

      if input == "save"
        save_game
        return
      elsif input.last == "-c"
        click_tile(input[0].first, input[0].last)
      elsif input.last == "-f"
        flag_tile(input[0].first, input[0].last)
      end
    end

    @board.display(show_bombs = true)
  end

  private

  def get_user_input
    puts "Type in the coordinates of a tile separated by a comma (row, col)," +
         " followed by -c for click or -f for flag (ex: 7,2 -c):"
    input = gets.chomp

    unless input == "save"
      input = input.split(" ")
      input[0] = input[0].split(",").map(&:to_i)
    end

    input
  end

  def save_game
    print "What should we call your save? "
    filename = gets.chomp
    File.write("#{filename}.yml", YAML.dump(self))
    puts "Game saved!"
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

if __FILE__ == $PROGRAM_NAME
  print "Would you like to start a new game or load a saved game (new/load)? "
  input = gets.chomp

  if input == "new"
    print "How wide would you like your board? "
    dimension = gets.chomp.to_i
    puts "At any time, you can save your game by typing 'save'"
    Minesweeper.new(dimension).play
  elsif input == "load"
    print "What is your save file's name? "
    filename = gets.chomp
    YAML.load_file("#{filename}.yml").play
  end
end



