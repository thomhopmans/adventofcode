class Exercise2
  MAX_RED = 12
  MAX_GREEN = 13
  MAX_BLUE = 14

  def run
    puts 'Exercise 2:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    instructions.map do |line|
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

  def run_b(instructions)
    instructions.map do |line|
      game_id = line.match(/Game (\d{1,3}):/)[1].to_i
      sets = line.split(': ')[1].split('; ')

      game_blues = 0
      game_greens = 0
      game_reds = 0

      sets.each do |set|
        blues = parse_color(set, 'blue')
        greens = parse_color(set, 'green')
        reds = parse_color(set, 'red')

        game_blues = [blues, game_blues].max
        game_greens = [greens, game_greens].max
        game_reds = [reds, game_reds].max
      end

      set_power = game_blues * game_greens * game_reds
      set_power
    end.sum
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise2.txt").split("\n")
  end
end
