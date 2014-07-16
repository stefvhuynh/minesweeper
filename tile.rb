class Tile
  
  NEIGHBOR_DELTAS = [
    [ 1,  0], [ 1,  1], 
    [ 0,  1], [-1,  1], 
    [-1,  0], [-1, -1], 
    [ 0, -1], [ 1, -1]
  ]
  
  attr_reader :row, :col
  
  def initialize(board, position)
    @board = board
    @row = position.first
    @col = position.last
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
  
  def neighbors
    [].tap do |neighbors|
      NEIGHBOR_DELTAS.each do |(drow, dcol)|
        if (@row + drow).between?(0, @board.dimension) &&
           (@col + dcol).between?(0, @board.dimension)
           
           neighbors << @board[@row + drow, @col + dcol]
        end
      end
    end
  end
  
  def inspect
    { :p => [@row, @col],
      :b => bombed?
    }.inspect
  end
  
end


