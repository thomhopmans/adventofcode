Point = Struct.new(:x, :y)

NORTH = [-1, 0].freeze
EAST = [0, 1].freeze
SOUTH = [1, 0].freeze
WEST = [0, -1].freeze

module Grid
  def plot_grid(grid)
    grid.each { |row| puts row.join }
  end
end
