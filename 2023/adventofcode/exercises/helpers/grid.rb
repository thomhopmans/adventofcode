module Grid
  def plot_grid(grid)
    grid.each { |row| puts row.join }
  end
end