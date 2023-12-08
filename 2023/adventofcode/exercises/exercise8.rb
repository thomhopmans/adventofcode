class Exercise8
  def run
    puts 'Exercise 8:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    # Parse
    instructions = instructions.split("\n")
    directions = instructions.first.chars

    nodes = instructions[2..].map do |line|
      node, left, right = line.scan(/\w{3}/)
      [node, [left, right]]
    end.to_h

    # Walk over the path
    path = ['AAA']

    while path.last != 'ZZZ'
      direction = directions.shift
      next_node = path.last
      path = decide(next_node, path, nodes, direction)
      directions.append(direction)
    end

    # First node does not count as a step
    path.size - 1
  end

  def run_b(instructions)
    # Parse
    instructions = instructions.split("\n")
    directions = instructions.first.chars

    nodes = instructions[2..].map do |line|
      node, left, right = line.scan(/\w{3}/)
      [node, [left, right]]
    end.to_h

    # Walk over the paths
    ghost_paths = nodes.keys.filter_map { |key| key if key.end_with?('A') }.map { |x| [x] }

    # Paths go in same-sized cycles, so exploit that property
    z_visits = ghost_paths.map do |path|
      path_directions = directions

      while path.last.end_with?('Z') == false
        current_direction = path_directions.shift
        current_node = path.last
        path = decide(current_node, path, nodes, current_direction)
        path_directions.append(current_direction)
      end

      path.size - 1
    end

    # Least common multiple over all the cycle durations
    z_visits.reduce(:lcm)
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise8.txt")
  end

  private

  def decide(current_node, path, nodes, direction)
    case direction
      when 'L'
        next_node = nodes[current_node][0]
      when 'R'
        next_node = nodes[current_node][1]
    end

    path << next_node
  end
end
