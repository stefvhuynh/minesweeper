class Tile
  attr_reader :x_pos, :y_pos
  
  def initialize(board, position)
    @board = board
    @x_pos = position.first
    @y_pos = position.last
    @bombed, @flagged, @revealed = false, false, false
  end
  
  def bombed?
    @bombed
  end
  
  def place_bomb
    @bombed = true
  end
  
  def flagged?
    @flagged
  end
  
  def place_flag
    @flagged = true
  end
  
  def revealed?
    @revealed
  end
  
  def reveal
    @revealed = true
    neighbor_bomb_count
  end
  
  def neighbor_bomb_count
    neighbor_bomb_count = 0
    neighbors.each { |neighbor| neighbor_bomb_count += 1 if neighbor.bombed? }
    neighbor_bomb_count
  end
  
  DELTAS = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1]]
  
  def neighbors
    neighbors = []
    
    DELTAS.each do |(dx, dy)|
      neighbors << @board[@x_pos + dx, @y_pos + dy]
    end
    
    neighbors
  end
  
  def inspect
    { :p => [@x_pos, @y_pos] }.inspect
  end
  
end


