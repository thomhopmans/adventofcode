require_relative 'helpers/exercise'

class Exercise01 < Exercise
  EXERCISE_NUMBER = 1

  WORD_TO_NUMBER = {
    'one' => '1',
    'two' => '2',
    'three' => '3',
    'four' => '4',
    'five' => '5',
    'six' => '6',
    'seven' => '7',
    'eight' => '8',
    'nine' => '9',
  }.freeze

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    data.split("\n").map do |line|
      x = line.scan(/\d/)
      calibration_value = (x.slice(0) + x.slice(-1)).to_i
      calibration_value
    end.sum
  end

  def run_b(data)
    data.split("\n").map do |line|
      first_digit = find_first_occurrence_of_digit(line, 0, 1)
      last_digit =  find_first_occurrence_of_digit(line, line.size - 1, -1)
      calibration_value = (first_digit + last_digit).to_i
      calibration_value
    end.sum
  end

  def find_first_occurrence_of_digit(x, start_index, direction)
    index = start_index

    until index < 0 || index >= x.length
      substring = x[index..]

      return x[index] if x[index].match?(/\A\d\z/)

      WORD_TO_NUMBER.each do |word, number|
        if substring.start_with?(word)
          return number
        end
      end

      index += direction
    end

    raise
  end
end
