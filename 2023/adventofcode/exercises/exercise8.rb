require_relative 'helpers/exercise'

class Exercise08 < Exercise
  EXERCISE_NUMBER = 8

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    # Parse
    instructions = instructions.split("\n")
    directions = instructions.first.chars
    nodes = to_nodes(instructions)

    # Walk over the path
    path = ['AAA']
    n_visits = 0
    while path.last != 'ZZZ'
      direction = directions[n_visits % directions.size]
      path = decide(path.last, path, nodes, direction)
      n_visits += 1
    end

    n_visits
  end

  def run_b(instructions)
    # Parse
    instructions = instructions.split("\n")
    directions = instructions.first.chars
    nodes = to_nodes(instructions)

    # Paths go in cycles with constant step size, so exploit that property
    ghosts = nodes.keys.filter_map { |key| [key] if key.end_with?('A') }
    ghosts.map do |path|
      n_visits = 0
      while path.last.end_with?('Z') == false
        direction = directions[n_visits % directions.size]
        path = decide(path.last, path, nodes, direction)
        n_visits += 1
      end
      n_visits
    end.reduce(:lcm) # Least common multiple over all the cycle durations
  end

  private

  def to_nodes(instructions)
    instructions[2..].to_h do |line|
      node, left, right = line.scan(/\w{3}/)
      [node, [left, right]]
    end
  end

  def decide(current_node, path, nodes_map, direction)
    case direction
      when 'L'
        next_node = nodes_map[current_node][0]
      when 'R'
        next_node = nodes_map[current_node][1]
    end

    path << next_node
  end
end
