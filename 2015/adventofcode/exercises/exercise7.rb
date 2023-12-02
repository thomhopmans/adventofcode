require 'digest'

EXERCISE = 7

class Exercise7
  def run
    puts "Exercise #{EXERCISE}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
  end

  def run_b(data)
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise#{EXERCISE}.txt")
  end
end

Exercise7.new.run
