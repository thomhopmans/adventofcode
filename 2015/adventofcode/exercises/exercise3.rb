class Exercise3
  def run
    puts 'Exercise 3'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    visited_houses = {}

    position = [0, 0]
    visited_houses[position] = 1

    instructions.chars.each do |sign|
      position = move(position, sign)
      visited_houses[position] = 1
    end

    visited_houses.keys.count
  end

  def run_b(instructions)
    n_steps = 1..instructions.chars.size
    visited_houses = {}

    position = [0, 0]
    visited_houses[position] = 1

    # Santa
    n_steps.select(&:odd?).each do |index|
      sign = instructions[index - 1]
      position = move(position, sign)
      visited_houses[position] = 1
    end

    # Robo-santa
    position = [0, 0]
    n_steps.select(&:even?).each do |index|
      sign = instructions[index - 1]
      position = move(position, sign)
      visited_houses[position] = 1
    end

    visited_houses.keys.count
  end

  def move(position, sign)
    case sign
      when '<'
        direction = [-1, 0]
      when '^'
        direction = [0, -1]
      when '>'
        direction = [1, 0]
      when 'v'
        direction = [0, 1]
      else
        puts x
    end
    position.map.with_index { |value, pos_index| value + direction[pos_index] }
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise3.txt")
  end
end
