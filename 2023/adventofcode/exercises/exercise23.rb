require_relative 'helpers/exercise'
require_relative 'helpers/grid'
require 'pp'

WALL = '#'.freeze

class Graph
  attr_accessor :adj_matrix, :nodes

  def initialize
    @nodes = []
    @adj_matrix = {}
  end

  def add_node(node)
    @nodes << node
    @adj_matrix[node] = {}
  end

  def add_edge(from, to)
    @adj_matrix[from][to] = 1
  end
end

def add_nodes(graph, grid)
  rows = grid.length
  cols = grid[0].length

  (0...rows).each do |r|
    (0...cols).each do |c|
      graph.add_node([r, c])
    end
  end
end

def add_adjacent_edges_with_slopes(graph, grid)
  rows = grid.length
  cols = grid[0].length

  # Helper function to check if coordinates are within the grid
  within_grid = lambda { |x, y| x >= 0 && x < rows && y >= 0 && y < cols }

  # Iterate through the grid to create nodes and edges
  (0...rows).each do |i|
    (0...cols).each do |j|
      next if grid[i][j] == WALL # Skip blocked cells or any other marker

      current_node = [i, j]

      neighbors = case grid[i][j]
        when '^'
          [NORTH]
        when '>'
          [EAST]
        when 'v'
          [SOUTH]
        when '<'
          [WEST]
        else
          [NORTH, EAST, SOUTH, WEST]
      end

      neighbors.each do |neighbor|
        x, y = elem_addition(current_node, neighbor)
        if within_grid.call(x, y) && grid[x][y] != WALL
          graph.add_edge(current_node, [x, y])
        end
      end
    end
  end

  graph
end

def elem_addition(array1, array2)
  array1.zip(array2).map { |a, b| a + b }
end

class Exercise23 < Exercise
  EXERCISE_NUMBER = 23

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    # puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    grid = to_grid(data)
    graph = Graph.new
    add_nodes(graph, grid)
    add_adjacent_edges_with_slopes(graph, grid)

    # Running DFS to find the longest path
    start = [0, 1]
    target = [grid.size - 1, grid.first.size - 2]

    @visited = {}
    @max_length = 0
    @max_path = []
    start_path = Set.new
    start_path.add(start)
    @candidate_stack = [[start, 0, start_path]]

    until @candidate_stack.empty?
      node, steps, path = @candidate_stack.pop
      perform(graph, target, node, steps, path)

    end

    @max_length
  end

  def plot_grid(grid)
    grid.each { |row| puts row.join }
  end

  def run_b(data)
    data = data.gsub('<', '.').gsub('^', '.').gsub('>', '.').gsub('v', '.')
    grid = to_grid(data)

    start = [0, 1]
    target = [grid.size - 1, grid.first.size - 2]

    adj_matrix = add_adjacent_edges_with_contractions(grid, start, target)

    graph = Graph.new
    graph.adj_matrix = adj_matrix

    # Running DFS to find the longest path
    @max_length = 0
    @max_path = []
    start_path = Set.new
    start_path.add(start)
    @candidate_stack = [[start, 0, start_path]]

    until @candidate_stack.empty?
      node, steps, path = @candidate_stack.pop
      perform(graph, target, node, steps, path)
    end

    @max_length - 1
  end

  private

  def to_grid(data)
    data.split("\n").map(&:chars)
  end

  def add_adjacent_edges_with_contractions(grid, start, target)
    adj_matrix = Hash.new { |h, k| h[k] = [] }
    queue = [[start, start, [start, [0, 1]]]]

    until queue.empty?

      curr_node, prev_node, visited = queue.pop

      if curr_node == target
        # Add last edge to adjacency matrix
        final_steps = visited.length - 1
        adj_matrix[prev_node] << [target, final_steps]
        next
      end

      y, x = curr_node
      neighbors = []

      [[y + 1, x], [y - 1, x], [y, x + 1], [y, x - 1]].each do |j, i|
        if !visited.include?([j, i]) && grid[j][i] != WALL
          neighbors << [j, i]
        end
      end

      if neighbors.length == 1 # neither intersection nor dead end
        nxt_xy = neighbors.pop
        queue << [nxt_xy, prev_node, visited + [nxt_xy]]
      elsif neighbors.length > 1 # found an intersection (node)
        steps = visited.length - 1
        unless adj_matrix[prev_node].include?([curr_node, steps]) # already been here
          adj_matrix[prev_node] << [curr_node, steps]
          adj_matrix[curr_node] << [prev_node, steps]

          until neighbors.empty? # start new paths from current node
            nxt_xy = neighbors.pop
            new_paths = Set.new([curr_node] + [nxt_xy]).to_a
            queue << [nxt_xy, curr_node, new_paths]
          end
        end
      end
    end

    adj_matrix
  end

  def perform(graph, target, node, steps, path)
    # Target reached
    if node == target

      if steps > @max_length
        @max_length = steps
        @max_path = path
      end

      return
    end

    # Neighbors
    graph.adj_matrix[node].each do |next_node, add_steps|
      next if path.include?(next_node)

      new_path = path.clone.add(next_node)
      @candidate_stack << [next_node, steps + add_steps, new_path]
    end
  end
end
