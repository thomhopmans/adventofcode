class Exercise6
  def run
    puts 'Exercise 6:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    sections = instructions.split("\n")
    times = sections[0].scan(/\d{1,20}+/).map(&:to_i)
    distances = sections[1].scan(/\d{1,20}+/).map(&:to_i)

    round_wins = (0...(times.size)).map do |round|
      wins = (0...times[round]).map { |hold_duration|
        simulation(times[round], distances[round], hold_duration)
      }.sum

      wins
    end

    round_wins.reduce(:*)
  end

  def simulation(max_time, distance_to_beat, hold_duration)
    speed_after_hold_duration = hold_duration * 1
    time_remaing_after_holding_button = max_time - hold_duration
    distance_travelled = time_remaing_after_holding_button * speed_after_hold_duration

    if distance_travelled > distance_to_beat
      1
    else
      0
    end
  end

  def run_b(instructions)
    sections = instructions.split("\n")
    racetime = sections[0].gsub(' ', '').scan(/\d{1,20}+/).map(&:to_i).first
    distance = sections[1].gsub(' ', '').scan(/\d{1,20}+/).map(&:to_i).first

    # traveldistance
    #   = holdtime * (racetime - holdtime)
    #   = -(holdtime**2)+(racetime*holdtime)
    #
    # Solving equations using the quadratric formula gives a = 1, b = racetime and c = distance
    #   i.e.
    #     holdtime_left = (-racetime + sqrt(racetime**2 - 4*traveldistance)) / -2
    #     holdtime_right = (-racetime - sqrt(racetime**2 - 4*traveldistance)) / -2

    hold_left = ((-racetime + Math.sqrt((racetime**2) - (4 * distance))) / -2).ceil
    hold_right = ((-racetime - Math.sqrt((racetime**2) - (4 * distance))) / -2).floor

    # Distance between two hold times are all times that beat the distance
    hold_right - hold_left + 1
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise6.txt")
  end
end

Exercise6.new.run
