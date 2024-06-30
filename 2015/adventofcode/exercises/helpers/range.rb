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

  def non_overlapping_subranges(other)
    non_overlapping_subranges = []

    # Check if self is entirely before other
    if self.end < other.begin
      non_overlapping_subranges << self
    elsif other.end < self.begin
      non_overlapping_subranges << other
    elsif self.begin < other.begin
      # Determine the non-overlapping subranges
      non_overlapping_subranges << (self.begin...other.begin) if self.begin < other.begin
      non_overlapping_subranges << (other.end...self.end) if other.end < self.end
    else
      non_overlapping_subranges << (other.begin...self.begin) if other.begin < self.begin
      non_overlapping_subranges << (self.end...other.end) if self.end < other.end
    end

    non_overlapping_subranges
  end
end
