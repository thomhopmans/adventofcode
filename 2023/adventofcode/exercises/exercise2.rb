require_relative 'helpers/exercise'

class Exercise02 < Exercise
  EXERCISE_NUMBER = 2

  MAX_RED = 12
  MAX_GREEN = 13
  MAX_BLUE = 14

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    data.split("\n").map do |line|
      game_id = line.match(/Game (\d{1,3}):/)[1].to_i
      sets = line.split(': ')[1].split('; ')

      all_sets_feasible = sets.map do |set|
        blues = parse_color(set, 'blue')
        greens = parse_color(set, 'green')
        reds = parse_color(set, 'red')

        # feasible set?
        (blues <= MAX_BLUE) && (greens <= MAX_GREEN) && (reds <= MAX_RED)
      end.all?

      game_id if all_sets_feasible
    end.compact.sum
  end

  def parse_color(set, color)
    count = set.match(/(\d{1,3}) #{color}/)
    (count[1].to_i if count) || 0
  end

  def run_b(data)
    data.split("\n").sum do |line|
      sets = line.split(': ')[1].split('; ')

      powers = sets.map do |set|
        blues = parse_color(set, 'blue')
        greens = parse_color(set, 'green')
        reds = parse_color(set, 'red')

        [blues, greens, reds]
      end.transpose.map { |color| color.max }

      powers.reduce(1, :*)
    end
  end
end
