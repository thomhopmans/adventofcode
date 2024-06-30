require_relative 'helpers/exercise'

class Exercise07 < Exercise
  EXERCISE_NUMBER = 7

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
  end

  def run_b(data)
  end
end
