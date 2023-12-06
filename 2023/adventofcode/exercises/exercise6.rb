require_relative 'helpers/range'

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
      wins = (0...times[round]).map {|hold_duration|
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
    times = sections[0].gsub(' ', '').scan(/\d{1,20}+/).map(&:to_i)
    distances = sections[1].gsub(' ', '').scan(/\d{1,20}+/).map(&:to_i)


    # Brute force all options. It works, but not very performant
    round_wins = (0...(times.size)).map do |round|
      wins = (0...times[round]).map {|hold_duration|
        simulation(times[round], distances[round], hold_duration)
      }.sum
      
      wins
    end

    round_wins.reduce(:*)
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise6.txt")
  end
end

Exercise6.new.run
