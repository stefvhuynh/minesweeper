require "./tile"

class Board
  
  def self.blank_grid(dimension)
    Array.new(dimension) { Array.new(dimension) }
  end
    
  def initialize(dimension = 9)
    @dimension = dimension
    @grid = self.class.blank_grid(dimension)
    populate_board
  end
  
  def [](x, y)
    # This is a custom bracket method that returns the object at row y, 
    # column x. We subtract the dimension from the y value and negate it.
    # This makes the bottom left corner the origin (0, 0), and y goes up
    # on the coordinate system rather than down. We need to subtract one
    # from the dimension because of 0-based indexing.
    @grid[-(y - (@dimension - 1))][x]
  end
  
  def []=(x, y, obj)
    @grid[-(y - (@dimension - 1))][x] = obj
  end
  
  def display
    puts render
  end
    
  private  
    
  # We define our own Board#each_index method to make iteration easier. We 
  # simply pass in a block and the arguments are the rows and columns.
  def each_index(&blk)
    @dimension.times do |row|
      @dimension.times { |col| blk.call(row, col) }
    end
    
    @grid
  end
  
  def populate_board
    self.each_index { |row, col| self[row, col] = Tile.new(self, [row, col]) }
    place_bombs
  end
  
  def place_bombs
    bomb_positions = random_tiles
    
    self.each_index do |row, col|
      self[row, col].place_bomb if bomb_positions.include?([row, col])
    end
  end
  
  def random_tiles
    [].tap do |random_tiles|
      10.times do |i| 
        random_tiles << [rand(0...@dimension), rand(0...@dimension)]
      end
    end
  end
  
  def render
    rendered = ""
    
    self.each_index do |row, col|
      if self[row, col].bombed?
        rendered += "* " 
      else
        rendered += "_ "
      end
      rendered += "\n" if col == @dimension - 1
    end
    
    rendered
  end
  
end

b = Board.new
b.display
p b[4, 4].neighbors



