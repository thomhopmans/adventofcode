class Exercise1
  def run
    puts 'Exercise 1:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    instructions.count('(') + (instructions.count(')') * -1)
  end

  def run_b(instructions)
    position = 1
    current_floor = 0

    instructions.chars.each do |x|
      direction = x == '(' ? 1 : -1
      current_floor += direction

      if current_floor == -1
        return position
      end

      position += 1
    end

    puts 'reached'
    position
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise1.txt")
  end
end

Exercise1.new.run
