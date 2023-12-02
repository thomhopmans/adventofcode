class Exercise2
  def run
    puts 'Exercise 2:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    sum_feasible_game_ids = 0

    instructions.each do |line|
      game_id = line.match(/Game (\d{1,3}):/)[1].to_i
      sets = line.split(': ')[1].split('; ')

      is_set_feasible = sets.map do |set|
        blues = parse_color(set, 'blue')
        greens = parse_color(set, 'green')
        reds = parse_color(set, 'red')

        # feasible set?
        max_red = 12
        max_green = 13
        max_blue = 14

        (blues <= max_blue) && (greens <= max_green) && (reds <= max_red)
      end

      if is_set_feasible.all?
        sum_feasible_game_ids += game_id
      end
    end

    sum_feasible_game_ids
  end

  def parse_color(set, color)
    count = set.match(/(\d{1,3}) #{color}/)
    (count[1].to_i if count) || 0
  end

  def run_b(instructions)
    sum_power_sets = 0

    instructions.each do |line|
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
      sum_power_sets += set_power
    end

    sum_power_sets
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise2.txt").split("\n")
  end
end

Exercise2.new.run
