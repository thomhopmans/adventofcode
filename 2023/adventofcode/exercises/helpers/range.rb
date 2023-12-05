
class Range
  def breakpoints(other)
    # Prase all range's start and end points in new array with breaking_points
    breaking_points = [other.begin, other.end]
    breaking_points.push(first, last).sort!

    sub_ranges = []
    breaking_points.each_cons(2) do |start_point, end_point|
      sub_ranges << (start_point...end_point)
    end
    sub_ranges
  end

  def any_intersect?(other)
    # A point in both ranges intersect
    !(max < other.begin || other.max < self.begin)
  end

  def intersection(other)
    return nil unless any_intersect?(other)

    [self.begin, other.begin].max...([max, other.max].min + 1)
  end

  def inclusive?(other)
    # Range fully within other range
    self.begin >= other.begin && self.end <= other.end
  end

  def +(other)
    (self.begin + other)...((max + other) + 1)
  end
end