class Exercise2
  def run
    puts 'Exercise 2'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    total_square_feet = 0

    instructions.each do |package|
      l, w, h = package.split('x').map(&:to_i)
      sides = [l * w, w * h, h * l]
      smallest_side = sides.min
      total_square_feet += ((sides.sum * 2) + smallest_side)
    end

    total_square_feet
  end

  def run_b(instructions)
    total_feet = 0

    instructions.each do |package|
      l, w, h = package.split('x').map(&:to_i)
      perimeters = [l + w, w + h, h + l].map { _1 * 2 }
      cubic_feet = l * w * h
      total_feet += perimeters.min + cubic_feet
    end

    total_feet
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise2.txt").split("\n")
  end
end
