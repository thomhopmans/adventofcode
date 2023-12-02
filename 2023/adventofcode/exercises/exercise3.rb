class Exercise2
  def run
    puts 'Exercise 3:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    sum_feasible_game_ids = 0

    instructions.each do |line|
      puts line
    end

    sum_feasible_game_ids
  end

  def run_b(instructions)
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise3.txt").split("\n")
  end
end

Exercise3.new.run
