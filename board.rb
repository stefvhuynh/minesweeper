require "./tile"

class Board
  
  def self.blank_grid(dimension)
    Array.new(dimension) { Array.new(dimension) }
  end
  
  attr_reader :dimension
    
  def initialize(dimension = 9)
    @dimension = dimension
    @grid = self.class.blank_grid(dimension)
    @exploded = false
    populate_board
  end
  
  def exploded?
    @exploded
  end
  
  def explode_board
    @exploded = true
  end
  
  def won?
    self.each_index do |row, col|
      return false if self[row, col].bombed? && !self[row, col].flagged?
    end
    
    true
  end
  
  def [](row, col)
    @grid[row][col]
  end
  
  def []=(row, col, obj)
    @grid[row][col] = obj
  end
  
  # Uses recursion to reveal tiles and their neighbors. The recursion 
  # terminates in a particular direction when the number of adj_bombs is
  # zero. This ensures you do not reveal a tile that is bombed.
  def reveal_tile(row, col)
    # Immediate exits if the first tile revealed (prior to the recursion)
    # is a bomb.
    if self[row, col].bombed?
      explode_board
      return
    end
    
    unless self[row, col].revealed? || self[row, col].flagged?
      self[row, col].adj_bombs = self[row, col].reveal
      if self[row, col].adj_bombs == 0 # Terminates when greater than 0
        self[row, col].neighbors.each { |tile| reveal_tile(tile.row, tile.col) }
      end
    end
  end
  
  def toggle_tile_flag(row, col)
    self[row, col].toggle_flag
  end
  
  def display(show_bombs = false)
    puts render(show_bombs)
  end
        
  # We define our own Board#each_index method to make iteration easier. We 
  # simply pass in a block and the arguments are the rows and columns.
  def each_index(&blk)
    @dimension.times do |row|
      @dimension.times { |col| blk.call(row, col) }
    end
    
    @grid
  end
  
  private
  
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
      until random_tiles.length == 10
        random_tiles << [rand(0...@dimension), rand(0...@dimension)]
        random_tiles.uniq!
      end
    end
  end
  
  def render(show_bombs = false)
    rendered = "  0 1 2 3 4 5 6 7 8\n"
    
    self.each_index do |row, col|
      rendered += "#{row} " if col == 0
      
      if show_bombs
        if self[row, col].bombed? && self[row, col].flagged?
          rendered += "⚐ "
        elsif self[row, col].bombed? && !self[row, col].flagged?
          rendered += "⥁ "
        elsif !self[row, col].bombed? && self[row, col].flagged?
          rendered += "⚑ "
        elsif !self[row, col].bombed? && self[row, col].revealed?
          tile_adj_bombs = self[row, col].adj_bombs
          rendered += (tile_adj_bombs > 0) ? "#{tile_adj_bombs} " : "⬚ "
        else # !self[row, col].bombed? && !self[row, col].revealed?
          rendered += "▦ "
        end
        
      else
        if self[row, col].flagged?
          rendered += "⚑ "
        elsif self[row, col].revealed?
          tile_adj_bombs = self[row, col].adj_bombs
          rendered += (tile_adj_bombs > 0) ? "#{tile_adj_bombs} " : "⬚ "
        else # !self[row, col].revealed?
          rendered += "▦ "
        end
      end
      
      rendered += "\n" if col == @dimension - 1
    end
    
    rendered
  end
  
end

# b = Board.new
# b.toggle_tile_flag(4, 5)
# b.display
# b.reveal_tile(8, 8)
# b.display(true)




