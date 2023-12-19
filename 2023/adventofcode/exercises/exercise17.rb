require_relative 'helpers/exercise'
require 'lazy_priority_queue'

NORTH = [-1, 0].freeze
EAST = [0, 1].freeze
SOUTH = [1, 0].freeze
WEST = [0, -1].freeze
DIRECTIONS = [NORTH, EAST, SOUTH, WEST].freeze

def calculate_direction(node1, node2)
  [node2[0] - node1[0], node2[1] - node1[1]]
end

class Graph
  attr_accessor :nodes, :edges

  def initialize
    @nodes = []
    @edges = {}
  end

  def add_node(node)
    @nodes << node
    @edges[node] = []
  end

  def add_edge(node1, node2, weight)
    @edges[node1] << { node: node2, weight: weight }
  end
end

class Exercise17 < Exercise
  EXERCISE_NUMBER = 17

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    grid = to_grid(data)
    start_node = [0, 0]
    target_node = [grid.size - 1, grid.last.size - 1]

    graph = Graph.new
    add_nodes(graph, grid)
    add_adjacent_edges(graph, grid)

    dijkstra(graph, start_node, target_node, false)
  end

  def run_b(data)
    grid = to_grid(data)
    start_node = [0, 0]
    target_node = [grid.size - 1, grid.last.size - 1]

    graph = Graph.new
    add_nodes(graph, grid)
    add_adjacent_edges(graph, grid)

    dijkstra(graph, start_node, target_node, true)
  end

  private

  def add_nodes(graph, grid)
    rows = grid.length
    cols = grid[0].length

    (0...rows).each do |r|
      (0...cols).each do |c|
        graph.add_node([r, c])
      end
    end
  end

  def add_adjacent_edges(graph, grid)
    rows = grid.length
    cols = grid[0].length

    (0...rows).each do |r|
      (0...cols).each do |c|
        DIRECTIONS.each do |direction|
          current_node = [r, c]
          new_node = elem_addition(current_node, direction)

          unless outside_grid?(grid, new_node)
            heat_loss_tile = grid[new_node[0]][new_node[1]]
            graph.add_edge(current_node, new_node, heat_loss_tile)
          end
        end
      end
    end
  end

  def dijkstra(graph, start, target, ultra_crucible)
    distance_map = Hash.new { |h, k| h[k] = Float::INFINITY }.merge(start => 0)
    priority_queue = MinPriorityQueue.new
    visited = Set.new

    graph.edges[start].each do |edge|
      node = edge[:node]
      weight = edge[:weight]
      priority_queue.push([weight, 1, calculate_direction(start, node), node], weight)
    end

    until priority_queue.empty?
      distance, straights, direction, node = priority_queue.pop

      if (node == target && !ultra_crucible) || (node == target && ultra_crucible && straights >= 4)
        return distance
      end

      # Visited?
      visited_key = [node, direction, straights]
      next if visited.include?(visited_key)

      visited.add(visited_key)

      # Search for feasible neighbours, and add to priority queue
      neighbors = feasible_adjacent_nodes(graph, node, direction, straights, ultra_crucible).compact
      neighbors.each do |(neighbor, weight, new_direction, new_straights)|
        new_distance = distance + weight
        key = [neighbor, new_direction, new_straights]

        if new_distance < distance_map[key]
          distance_map[key] = new_distance
          priority_queue.push([new_distance, new_straights, new_direction, neighbor], new_distance)
        end
      end
    end

    Float::INFINITY
  end

  def feasible_adjacent_nodes(graph, node, current_direction, straights, ultra_crucible)
    # Find adjacent nodes
    adjacent_nodes = graph.edges[node].filter_map do |edge|
      other_node = edge[:node]
      weight = edge[:weight]
      new_direction = calculate_direction(node, other_node)

      if new_direction == current_direction
        [other_node, weight, new_direction, straights + 1]
      elsif opposite_directions?(current_direction, new_direction)
        nil
      else
        [other_node, weight, new_direction, 1]
      end
    end

    # Apply constraints
    adjacent_nodes.filter_map do |(other_node, weight, new_direction, new_straights)|
      if ultra_crucible
        next unless new_straights <= 10 && (new_direction == current_direction || straights >= 4)
      elsif new_straights > 3
        next
      end
      [other_node, weight, new_direction, new_straights]
    end
  end

  def opposite_directions?(first_direction, second_direction)
    (first_direction[0] == -second_direction[0]) && (first_direction[1] == -second_direction[1])
  end

  def elem_addition(array1, array2)
    array1.zip(array2).map { |a, b| a + b }
  end

  def outside_grid?(grid, position)
    position[0].negative? || position[0] >= grid.length || position[1].negative? || position[1] >= grid[0].length
  end

  def to_grid(data)
    data.split("\n").map { |line| line.chars.map(&:to_i) }
  end
end
