require_relative 'helpers/exercise'

class UnionFind
  attr_accessor :parent, :rank, :count

  def initialize(items = nil)
    @parent = items.to_h { |item| [item, item] }
    @rank = items.to_h { |item| [item, 0] }
    @count = items.length || 0
  end

  def add(item)
    unless @parent.key?(item)
      @parent[item] = item
      @rank[item] = 0
      @count += 1
    end
  end

  def find(item)
    if @parent[item] != item
      @parent[item] = find(@parent[item])
    end
    @parent[item]
  end

  def union(item1, item2)
    item1 = find(item1)
    item2 = find(item2)
    if @rank[item1] < @rank[item2]
      item1, item2 = item2, item1
    elsif item1 != item2 && @rank[item1] == @rank[item2]
      @rank[item1] += 1
    end
    @parent[item2] = item1
    @count -= (item1 == item2 ? 0 : 1)
  end

  def sets
    roots = {}
    @parent.keys.each do |item|
      root = find(item)
      unless roots.include?(root)
        roots[root] = Set.new
      end
      roots[root].add(item)
    end
    roots.values.to_a
  end
end

class Exercise25 < Exercise
  EXERCISE_NUMBER = 25

  class Graph
    attr_accessor :nodes, :edges

    def initialize
      @nodes = Set.new
      @edges = {}
    end

    def add_node(node)
      unless @nodes.include?(node)
        @nodes.add(node)
        @edges[node] = Set.new
      end
    end

    def add_edge(node1, node2)
      unless @edges[node1].include?(node2)
        @edges[node1].add(node2)
      end
      unless @edges[node2].include?(node1)
        @edges[node2] << node1
      end
    end
  end

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts 'B: -'
  end

  def run_a(data)
    connections = to_connections(data)
    graph = create_graph(connections)
    a, b = karger_min_cut(graph)

    a.length * b.length
  end

  def run_b(data)
  end

  private

  def create_graph(connections)
    graph = Graph.new
    connections.each do |component, other_components|
      graph.add_node(component)
      other_components.each do |other_component|
        graph.add_node(other_component)
        graph.add_edge(component, other_component)
      end
    end
    graph
  end

  def to_connections(data)
    data.split("\n").map { |line| line.scan(/\b\w{3}\b/) }.map { |x| [x[0], x[1..]] }.to_h
  end

  def karger_min_cut(graph)
    # Karger's algorithm to find the minimum cut
    a = nil
    b = nil

    # Iterative until the random permutations find the correct minimum cut of size 3
    loop do
      union_find = UnionFind.new(graph.edges.keys)
      shuffled_edges = graph.edges.flat_map { |node, edges| edges.map { |other_node| [node, other_node] } }.shuffle
      shuffled_edges.each do |a, b|
        if union_find.find(a) != union_find.find(b)
          union_find.union(a, b)
          break if union_find.count == 2
        end
      end

      a, b = union_find.sets
      c = graph.edges.map { |node, edges| edges.map { |other_node| a.include?(node) & b.include?(other_node) ? 1 : 0 } }.flatten.sum

      next unless c == 3

      break
    end

    [a, b]
  end
end
