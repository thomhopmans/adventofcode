require_relative 'helpers/exercise'

class Exercise1 < Exercise
  EXERCISE_NUMBER = 1

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    calibration_sum = 0

    instructions.split("\n").each do |line|
      x = line.scan(/\d/)
      calibration_value = (x.slice(0) + x.slice(-1)).to_i
      calibration_sum += calibration_value
    end

    calibration_sum
  end

  def run_b(instructions)
    calibration_sum = 0

    instructions.split("\n").each do |line|
      first_digit = find_first_occurence_of_digit(line, 0, 1)
      last_digit =  find_first_occurence_of_digit(line, line.size - 1, -1)
      calibration_value = (first_digit + last_digit).to_i
      calibration_sum += calibration_value
    end

    calibration_sum
  end

  def find_first_occurence_of_digit(x, start_index, direction)
    value = ''
    index = start_index
    until 1 < -1
      substring = x[index..]

      if x[index].match?(/\A\d\z/)
        return x[index]
      elsif substring.start_with?('one')
        return '1'
      elsif substring.start_with?('two')
        return '2'
      elsif substring.start_with?('three')
        return '3'
      elsif substring.start_with?('four')
        return '4'
      elsif substring.start_with?('five')
        return '5'
      elsif substring.start_with?('six')
        return '6'
      elsif substring.start_with?('seven')
        return '7'
      elsif substring.start_with?('eight')
        return '8'
      elsif substring.start_with?('nine')
        return '9'
      else
        index += direction
      end
    end

    value
  end
end
