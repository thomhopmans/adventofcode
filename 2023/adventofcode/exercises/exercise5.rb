require_relative 'helpers/range'

class Exercise5
  def run
    puts 'Exercise 5:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    sections = instructions.split("\n\n")

    # Parse
    seeds = sections[0].scan(/\d{1,20}+/).map(&:to_i)

    maps = {}
    sections[1..].map do |section|
      section = section.split("\n")

      name = section[0].split(' map:')[0]
      maps[name] = []

      mappings = section[1..]
      mappings.each do |line|
        digits = line.scan(/\d{1,19}+/).map(&:to_i)
        maps[name].append({
          destination_range: digits[0]..(digits[0] + digits[2]),
          source_range: digits[1]..(digits[1] + digits[2]),
          delta: digits[0] - digits[1],
        })
      end
    end

    # Run mapping
    location_numbers = seeds.map do |seed|
      destination_id = run_mapping(seed, maps)
      destination_id
    end

    # 525792406
    location_numbers.min
  end

  def run_b(instructions)
    # Parse
    pair_seeds = true
    sections = instructions.split("\n\n")

    seeds = sections[0].scan(/\d{1,20}+/).map(&:to_i)
    if pair_seeds
      seeds = seeds.each_slice(2).to_a.map { _1...(_1 + _2) }
    end

    maps = sections[1..].map.with_index do |section, _section_index|
      section = section.split("\n")

      map_ranges = section[1..].map do |line|
        digits = line.scan(/\d{1,19}+/).map(&:to_i)
        {
          source_range: digits[1]...(digits[1] + digits[2]),
          delta: digits[0] - digits[1],
        }
      end
      map_ranges
    end

    # Run seeds through mappings to location
    answers = seeds.flat_map { recursive_search(_1, maps, 0) }

    # 79004094
    answers.flatten.map(&:begin).min
  end

  def recursive_search(seeds, maps, i)
    return [seeds] unless maps[i]

    map_ranges = maps[i].select { seeds.any_intersect?(_1[:source_range]) }

    new_seeds = if map_ranges.empty?
      # No overlapping ranges, so delta = 0
      [seeds]
    else
      # Break down the existing map ranges to more useful subranges that cover each case
      subranges = split_in_non_overlapping_ranges([seeds, *map_ranges.map { _1[:source_range] }])
      complete_mapping = subranges.map { |s|
        map_ranges.filter_map { |c|
          if s.inclusive?(c[:source_range])
            {
              source_range: s,
              delta: c[:delta],
            }
          end
        }
      }.flatten.compact

      # If subrange is in seeds, but not in mapped ranges, add to map with delta = 0
      present_sources = complete_mapping.map { _1[:source_range] }
      opposite_of_intersection = (subranges | present_sources) - (subranges & present_sources)
      opposite_of_intersection.each do |x|
        complete_mapping << { source_range: x, delta: 0 }
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

    breakpoints.map.each_with_index do |point, index|
      next if index + 1 >= breakpoints.size

      first = point
      last = breakpoints[index + 1]

      next if first == last

      (first...last)
    end.compact
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise5.txt")
  end

  private

  def run_mapping(seed, maps)
    # With names to simplify debugging
    source_id = seed
    destination_id = map_source_to_destination(maps, 'seed-to-soil', source_id)
    destination_id = map_source_to_destination(maps, 'soil-to-fertilizer', destination_id)
    destination_id = map_source_to_destination(maps, 'fertilizer-to-water', destination_id)
    destination_id = map_source_to_destination(maps, 'water-to-light', destination_id)
    destination_id = map_source_to_destination(maps, 'light-to-temperature', destination_id)
    destination_id = map_source_to_destination(maps, 'temperature-to-humidity', destination_id)
    map_source_to_destination(maps, 'humidity-to-location', destination_id)
  end

  def map_source_to_destination(maps, map_name, source_id)
    map_range_match = maps[map_name].filter { |x| x[:source_range].include?(source_id) }.first
    if map_range_match
      source_id + map_range_match[:delta]
    else
      source_id
    end
  end
end
