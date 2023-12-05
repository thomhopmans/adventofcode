class Range
  def breakpoints(other)
    # Include range's start and end points in breaking_points array
    breaking_points = [other.begin, other.end]
    breaking_points.push(first, last).sort!

    sub_ranges = []
    breaking_points.each_cons(2) do |start_point, end_point|
      sub_ranges << (start_point...end_point)
    end
    sub_ranges
  end

  def intersect?(other)
    !(max < other.begin || other.max < self.begin)
  end

  def intersection(other)
    return nil unless intersect?(other)

    [self.begin, other.begin].max...([max, other.max].min + 1)
  end

  def +(other)
    (self.begin + other)...((max + other) + 1)
  end
end

class Exercise5
  def run
    puts 'Exercise 5:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    sections = instructions.split("\n\n")

    # Parse
    seeds = []
    mappings_per_group = {}
    sections.map do |section|
      if section.start_with?('seeds')
        seeds = section.scan(/\d{1,20}+/).map(&:to_i)
      else
        section = section.split("\n")

        name = section[0].split(' map:')[0]
        mappings_per_group[name] = []

        mappings = section[1..]
        mappings.each do |line|
          digits = line.scan(/\d{1,19}+/).map(&:to_i)
          mappings_per_group[name].append({
            destination_range_start: digits[0],
            destination_range_end: digits[0] + digits[2],
            source_range_start: digits[1],
            source_range_end: digits[1] + digits[2],
            range_length: digits[2],
            delta_id: digits[0] - digits[1],
          })
        end
      end
    end

    # Run mapping
    location_numbers = seeds.map do |seed|
      destination_id = run_mapping(seed, mappings_per_group)
      destination_id
    end

    # 525792406
    location_numbers.min
  end

  def run_b(instructions)
    pair_seeds = true

    sections = instructions.split("\n\n")

    # Parse
    seeds = []
    maps = []
    sections.map.with_index do |section, _section_index|
      if section.start_with?('seeds')
        seeds = section.scan(/\d{1,20}+/).map(&:to_i)
        if pair_seeds
          seeds = seeds.each_slice(2).to_a.map { _1...(_1 + _2) }
        end
      else
        section = section.split("\n")

        map_ranges = section[1..].map do |line|
          digits = line.scan(/\d{1,19}+/).map(&:to_i)
          {
            source_range: digits[1]...(digits[1] + digits[2]),
            delta: digits[0] - digits[1],
          }
        end
        maps.append(map_ranges)
      end
    end

    # Run mapping
    answers = seeds.flat_map { recursive_search(_1, maps, 0) }

    # 79004094
    answers.flatten.map(&:begin).min
  end

  def recursive_search(seeds, maps, i)
    return [seeds] unless maps[i]

    map_ranges = maps[i].select { seeds.intersect?(_1[:source_range]) }

    new_seeds = if map_ranges.empty?
      # No overlapping ranges, so delta = 0
      [seeds]
    else
      # Break down the existing map ranges to more useful subranges that cover each case
      subranges = split_in_non_overlapping_ranges([seeds, *map_ranges.map { _1[:source_range] }])

      complete_mapping = subranges.map { |s|
        map_ranges.filter_map { |c|
          if inclusive?(s, c[:source_range])
            {
              source_range: s,
              delta: c[:delta],
            }
          end
        }
      }.flatten.compact

      # If value is in seeds, but not in mapped ranges, delta = 0
      present_sources = complete_mapping.map { _1[:source_range] }
      opposite_of_intersection = (subranges | present_sources) - (subranges & present_sources)
      opposite_of_intersection.each do |x|
        complete_mapping << {
          source_range: x,
          delta: 0,
        }
      end

      # Map all new sources with our new complete mapping
      seeds = complete_mapping.filter_map { |x|
        (seeds.intersection(x[:source_range]) + x[:delta]) if seeds.intersection(x[:source_range])
      }.compact

      seeds
    end

    new_seeds.flat_map { recursive_search(_1, maps, i + 1) }
  end

  def split_in_non_overlapping_ranges(ranges)
    breakpoints = ranges.flat_map { |range| [range.first, range.last] }.sort

    result = []
    breakpoints[0..-1].each_with_index do |point, index|
      next if index + 1 >= breakpoints.size

      start = point
      last = breakpoints[index + 1]

      next if start == last

      result << (start...last)
    end

    result
  end

  def inclusive?(one, other)
    one.begin >= other.begin && one.end <= other.end
  end

  private

  def run_mapping(seed, mappings_per_group)
    source_id = seed
    destination_id = map_source_to_destination(mappings_per_group, 'seed-to-soil', source_id)
    destination_id = map_source_to_destination(mappings_per_group, 'soil-to-fertilizer', destination_id)
    destination_id = map_source_to_destination(mappings_per_group, 'fertilizer-to-water', destination_id)
    destination_id = map_source_to_destination(mappings_per_group, 'water-to-light', destination_id)
    destination_id = map_source_to_destination(mappings_per_group, 'light-to-temperature', destination_id)
    destination_id = map_source_to_destination(mappings_per_group, 'temperature-to-humidity', destination_id)
    map_source_to_destination(mappings_per_group, 'humidity-to-location', destination_id)
  end

  def map_source_to_destination(mappings_per_group, map_name, source_id)
    map_range_match = mappings_per_group[map_name].filter { |x| source_id >= x[:source_range_start] && source_id <= x[:source_range_end] }
    if map_range_match.size > 0
      source_id + map_range_match[0][:delta_id]
    else
      source_id
    end
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise5.txt")
  end
end

Exercise5.new.run
