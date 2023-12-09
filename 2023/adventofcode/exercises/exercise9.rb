class Exercise9
  def run
    puts 'Exercise 9:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    # Extrapolate next number
    to_observations(data).map do |value_histories|
      # Find X-order differences until all are zero
      value_histories = [value_histories]
      value_histories.unshift(diff(value_histories.first)) until all_zero?(value_histories)

      # Sum over last numbers in histories
      value_histories[...-1].each.with_index do |row, index|
        value_histories[index + 1].append(row.last + value_histories[index + 1].last)
      end

      value_histories.last.last
    end.sum
  end

  def run_b(data)
    # Extrapolate previous number
    to_observations(data).map do |value_histories|
      # Find X-order differences until all are zero
      value_histories = [value_histories]
      value_histories.unshift(diff(value_histories.first)) until all_zero?(value_histories)

      # Sum over first numbers in histories
      value_histories[...-1].each.with_index do |row, index|
        value_histories[index + 1].unshift(- row.first + value_histories[index + 1].first)
      end

      value_histories.last.first
    end.sum
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise9.txt")
  end

  private

  def to_observations(data)
    data.split("\n").map { _1.split.map(&:to_i) }
  end

  def all_zero?(values)
    values.first.all?(&:zero?)
  end

  def diff(values)
    # Difference between each value pair in the Array
    differences = []
    values.each_cons(2) do |a, b|
      differences << (b - a)
    end
    differences
  end
end
