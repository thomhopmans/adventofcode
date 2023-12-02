require 'digest'

EXERCISE = 6

class Exercise6
  def run
    puts "Exercise #{EXERCISE}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    @grid = {}

    data.each do |instruction|
      from, to = instruction.scan(/\d+(?:,\d+)*/)
      from_x, from_y = from.split(',').map(&:to_i)
      to_x, to_y = to.split(',').map(&:to_i)

      case instruction
        when /\A(toggle)\b/
          (from_x..to_x).each do |x|
            (from_y..to_y).each do |y|
              toggle([x, y])
            end
          end
        when /\A(turn on)\b/
          (from_x..to_x).each do |x|
            (from_y..to_y).each do |y|
              turn_on([x, y])
            end
          end
        when /\A(turn off)\b/
          (from_x..to_x).each do |x|
            (from_y..to_y).each do |y|
              turn_off([x, y])
            end
          end
      end
    end

    @grid.values.reduce(0) { |total, value| total + value }
  end

  def toggle(pos)
    @grid[pos] = if @grid.key?(pos)
      1 - @grid[pos]
    else
      1
    end
  end

  def turn_on(pos)
    @grid[pos] = 1
  end

  def turn_off(pos)
    @grid[pos] = 0
  end

  def run_b(data)
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise#{EXERCISE}.txt").split("\n")
  end
end

Exercise6.new.run
