require "./tile"

class Board
  
  def self.blank_grid(dimension)
    Array.new(dimension) { Array.new(dimension) }
  end
  
  attr_reader :dimension, :exploded
    
  def initialize(dimension = 9)
    @dimension = dimension
    @grid = self.class.blank_grid(dimension)
    @exploded = false
    populate_board
  end
  
  def [](row, col)
    @grid[row][col]
  end
  
  def []=(row, col, obj)
    @grid[row][col] = obj
  end
  
  def reveal_tile(row, col)
    if self[row, col].bombed?
      @exploded = true
      return
    end
    
    unless self[row, col].revealed?
      self[row, col].adj_bombs = self[row, col].reveal
      if self[row, col].adj_bombs == 0
        self[row, col].neighbors.each { |tile| reveal_tile(tile.row, tile.col) }
      end
    end
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
    rendered = "  0 1 2 3 4 5 6 7 8\n"
    
    self.each_index do |row, col|
      rendered += "#{row} " if col == 0
      
      if self[row, col].revealed?
        if self[row, col].adj_bombs == 0
          rendered += "  "
        else
          rendered += "#{self[row, col].adj_bombs} "
        end
      elsif self[row, col].bombed?
          rendered += "* " 
      else
        rendered += "- "
      end
      rendered += "\n" if x == @dimension - 1
    end
    
    rendered
  end
  
end

b = Board.new
b.display
b.reveal_tile(8, 8)
b.display
p b[8, 8].neighbors
p b.exploded



