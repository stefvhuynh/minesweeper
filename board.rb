require "./tile"

class Board
  
  def self.blank_grid(dimension)
    Array.new(dimension) { Array.new(dimension) }
  end
  
  attr_reader :dimension
    
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
        
  # We define our own Board#each_index method to make iteration easier. We 
  # simply pass in a block and the arguments are the rows and columns.
  def each_index(&blk)
    @dimension.times do |row|
      @dimension.times { |col| blk.call(col, row) }
    end
    
    @grid
  end
  
  private
  
  def populate_board
    self.each_index { |x, y| self[x, y] = Tile.new(self, [x, y]) }
    place_bombs
  end
  
  def place_bombs
    bomb_positions = random_tiles
    
    self.each_index do |x, y|
      self[x, y].place_bomb if bomb_positions.include?([x, y])
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
    
    self.each_index do |x, y|
      rendered += "#{-(y - (@dimension - 1))} " if x == 0
      
      if self[x, y].bombed?
        rendered += "* " 
      else
        rendered += "_ "
      end
      rendered += "\n" if x == @dimension - 1
    end
    
    rendered += "  0 1 2 3 4 5 6 7 8"
  end
  
end

b = Board.new
b.display
p b[0, 0].neighbors
p b[0, 0].reveal



