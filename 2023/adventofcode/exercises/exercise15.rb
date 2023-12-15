require_relative 'helpers/exercise'

class Exercise15 < Exercise
  EXERCISE_NUMBER = 15

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    to_steps(data).map do |step|
      verification_number = hash(step)
      verification_number
    end.sum
  end

  def hash(value)
    current_value = 0
    value.chars.map do |x|
      ascii_code = x.ord
      current_value += ascii_code
      current_value *= 17
      current_value %= 256
    end
    current_value
  end

  def run_b(data)
    steps = to_steps(data)
    boxes = add_lenses_to_boxes(steps)
    calculate_power(boxes)
  end

  def add_lenses_to_boxes(steps)
    boxes = Hash.new { |hash, key| hash[key] = {} }

    steps.each do |step|
      label = /(\w+)[-=]/.match(step)[1]
      box = hash(label)

      if step.include?('=')
        # Update box content with label and its value
        boxes[box].merge!({ label => step[-1].to_i })
      elsif step.include?('-') && boxes[box].key?(label)
        # Remove label from box if it exists
        boxes[box].delete(label)
      end
    end

    boxes
  end

  def calculate_power(boxes)
    total_power = 0

    boxes.each do |box_number, contents|
      contents.each_with_index do |(_key, focal_length), slot_number|
        focusing_power = (box_number + 1) * (slot_number + 1) * focal_length
        total_power += focusing_power
      end
    end

    total_power
  end

  private

  def to_steps(data)
    data.gsub("\n", '').split(',')
  end
end
