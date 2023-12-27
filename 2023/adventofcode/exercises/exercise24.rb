require_relative 'helpers/exercise'

module GaussianElimination
  def self.solve(coefficients, constants)
    n = coefficients.size

    # Augmenting the matrix with the constants
    augmented_matrix = coefficients.map.with_index { |row, i| row + [constants[i]] }

    # Forward elimination
    (0..n - 1).each do |i|
      pivot = augmented_matrix[i][i]

      # Normalize the current row
      augmented_matrix[i] = augmented_matrix[i].map { |element| element / pivot }

      # Eliminate other rows
      (0..n - 1).each do |j|
        next if i == j

        factor = augmented_matrix[j][i]
        augmented_matrix[j] = augmented_matrix[j].each_with_index.map do |element, k|
          element - (factor * augmented_matrix[i][k])
        end
      end
    end

    # Back substitution
    augmented_matrix.map(&:last)
  end
end

Hailstone = Struct.new(:x, :y, :z, :vx, :vy, :vz)

class Exercise24 < Exercise
  EXERCISE_NUMBER = 24

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data, min_value: 200000000000000, max_value: 400000000000000)
    hailstones = to_lines(data)

    crossings = 0

    combinations(hailstones).each do |hailstone1, hailstone2|
      x1_0 = hailstone1[0]
      x2_0 = hailstone2[0]

      y1_0 = hailstone1[1]
      y2_0 = hailstone2[1]

      v1_x = hailstone1[3]
      v2_x = hailstone2[3]

      v1_y = hailstone1[4]
      v2_y = hailstone2[4]

      time_of_intersection = solve_linear_equations(v1_x, -v2_x, x2_0 - x1_0, v1_y, -v2_y, y2_0 - y1_0)

      next if time_of_intersection.nil? || time_of_intersection.min < 0

      pos_at_intersection = pos_at_t(x1_0, v1_x, y1_0, v1_y, time_of_intersection[0])

      if pos_at_intersection.min >= min_value && pos_at_intersection.max <= max_value
        crossings += 1
      end
    end

    crossings
  end

  def run_b(data)
    hailstones = to_lines(data)

    # Solve set of linear equations to find intersections between first 4 hailstones
    set_coefficients = []
    set_constants = []
    combinations(hailstones).first(4).each do |one, two|
      coefficients, constant = linear_equation_coefficients(one, two)
      set_coefficients << coefficients
      set_constants.append(constant)
    end

    x, dx, y, = GaussianElimination.solve(set_coefficients, set_constants)
    t0, t1 = solve_for_t(x, dx, hailstones[0], hailstones[1])
    z, = extract_z_from_first_intersections(t0, t1, hailstones[0], hailstones[1])

    x.round(0) + y.round(0) + z.round(0)
  end

  def combinations(hailstones)
    combinations = Set.new
    hailstones.each_with_index do |row1, index1|
      hailstones.each_with_index do |row2, index2|
        next if index1 == index2
        next if combinations.include?([row2, row1])

        combinations.add([row1, row2])
      end
    end
    combinations
  end

  private

  def linear_equation_coefficients(hailstone1, hailstone2)
    # Set of hailstone equations can be reduced to a linear form: a*x + b*dx + c * y + d * dy = constant
    #
    # (vy1 - vy2) * x + ( y2 - y1 ) * dx + (vx2 - vx1) * y + (x1 - x2) * dy
    #   = vy1 * x1 - vx1 * y1 + dd * y2 - vy2 * x2
    x1 = hailstone1[0]
    x2 = hailstone2[0]
    y1 = hailstone1[1]
    y2 = hailstone2[1]

    vx1 = hailstone1[3]
    vy1 = hailstone1[4]
    vx2 = hailstone2[3]
    vy2 = hailstone2[4]

    coefficients = [vy1 - vy2, y2 - y1, vx2 - vx1, x1 - x2].map(&:to_f)
    constant = ((vy1 * x1) - (vx1 * y1) + (vx2 * y2) - (vy2 * x2)).to_f

    [coefficients, constant]
  end

  def solve_for_t(x, dx, hailstone1, hailstone2)
    x0 = hailstone1[0]
    vx0 = hailstone1[3]
    vx1 = hailstone2[3]
    x1 = hailstone2[0]

    t0 = (x0 - x) / (dx - vx0)
    t1 = (x1 - x) / (dx - vx1)

    [t0, t1]
  end

  def extract_z_from_first_intersections(t0, t1, hailstone1, hailstone2)
    z1 = hailstone1[2]
    vz1 = hailstone1[5]
    z2 = hailstone2[2]
    vz2 = hailstone2[5]

    r1 = z1 + (vz1 * t0)
    r2 = z2 + (vz2 * t1)

    dz = (r2 - r1) / (t1 - t0)
    z = r1 - (dz * t0)

    [z, dz]
  end

  def to_lines(data)
    data.split("\n").map { |line| line.scan(/-?\d+/).map(&:to_f) }
  end

  # Function to solve linear equations
  def solve_linear_equations(a1, b1, c1, a2, b2, c2)
    det = (a1 * b2) - (a2 * b1)
    return nil if det.zero?

    t_one = ((c1 * b2) - (c2 * b1)) / det
    t_two = ((a1 * c2) - (a2 * c1)) / det
    [t_one, t_two]
  end

  def pos_at_t(x_0, v_x, y_0, v_y, time_of_intersection)
    [(x_0 + (v_x * time_of_intersection)).round(2), (y_0 + (v_y * time_of_intersection)).round(2)]
  end
end
