class Tile

  NEIGHBOR_DELTAS = [
    [ 1,  0], [ 1,  1],
    [ 0,  1], [-1,  1],
    [-1,  0], [-1, -1],
    [ 0, -1], [ 1, -1]
  ]

  attr_reader :row, :col
  attr_accessor :adj_bombs

  def initialize(board, position)
    @board = board
    @row, @col = position.first, position.last
    @bombed, @flagged, @revealed = false, false, false
    @adj_bombs = 0
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

  def toggle_flag
    @flagged = !@flagged
  end

  def revealed?
    @revealed
  end

  def reveal
    @revealed = true
    @adj_bombs = neighbor_bomb_count
  end

  def neighbor_bomb_count
    neighbor_bomb_count = 0
    neighbors.each { |neighbor| neighbor_bomb_count += 1 if neighbor.bombed? }
    neighbor_bomb_count
  end

  def neighbors
    [].tap do |neighbors|
      NEIGHBOR_DELTAS.each do |(drow, dcol)|
        if (@row + drow).between?(0, @board.dimension - 1) &&
           (@col + dcol).between?(0, @board.dimension - 1)

           neighbors << @board[@row + drow, @col + dcol]
        end
      end
    end
  end

end


