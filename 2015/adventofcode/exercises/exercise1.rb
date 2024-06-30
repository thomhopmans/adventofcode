require_relative 'helpers/exercise'

class Exercise01 < Exercise
  EXERCISE_NUMBER = 1

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
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
end
