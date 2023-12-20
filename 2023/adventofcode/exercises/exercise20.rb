require_relative 'helpers/exercise'

class Exercise20 < Exercise
  EXERCISE_NUMBER = 20

  LOW_PULSE = false
  HIGH_PULSE = true

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    flip_flops, conjunctions, module_map = parse_cables(data)

    output = (1..1000).map do |iteration|
      push_button(iteration, module_map, flip_flops, conjunctions)
    end

    output_a, output_b = output.transpose.map(&:sum)
    output_a * output_b
  end

  # kh is the only input to rx and it is a conjunction
  # > If kh gets all high pulses, it will send a low pulse to rx, and we are done
  #
  # In turn, kh has as input 4 conjunctions.
  # > For each of those 4 conjunction, it must hold that:
  #   memory inflow is not all high pulses, because then it will send a high pulse to kh
  def run_b(data)
    flip_flops, conjunctions, module_map = parse_cables(data)

    # 4080 is exactly sufficient for my input
    (1..4080).map do |iteration|
      push_button(iteration, module_map, flip_flops, conjunctions)
    end

    conjunctions_to_kh = ['pv', 'qh', 'xm', 'hz'].freeze
    relevant_conjunctions = @conjunctions_first_high_pulse
      .select { |key, _| conjunctions_to_kh.include?(key) }
      .values

    relevant_conjunctions.reduce(&:lcm) # LCM to make use of the cycles
  end

  private

  def parse_cables(data)
    flip_flops = {}
    conjunctions = {}
    module_map = {}

    data.split("\n").map do |line|
      t = line.split(' -> ')
      [t[0], t[1].split(', ')]
    end.each do |name, where|
      if name[0] == '%'
        flip_flops[name[1..-1]] = false
        module_map[name[1..-1]] = where
        next
      end

      if name[0] == '&'
        conjunctions[name[1..-1]] = {}
        module_map[name[1..-1]] = where
        next
      end

      module_map[name] = where
    end

    conjunctions.keys.each do |c|
      module_map.each do |name, where|
        conjunctions[c][name] = false if where.include?(c)
      end
    end

    @conjunctions_first_high_pulse = Hash.new(0) # Helper for part B
    [flip_flops, conjunctions, module_map]
  end

  def push_button(iteration, module_map, flip_flops, conjunctions)
    queue = []
    a = 0
    b = 1

    # Broadcast signal at start
    module_map['broadcaster'].each do |w|
      queue.push([w, LOW_PULSE, 'broadcaster'])
    end

    # Process all cables
    until queue.empty?
      to, impulse, from = queue.shift

      if impulse == HIGH_PULSE
        a += 1
      else
        b += 1
      end

      if flip_flops.key?(to)
        next if impulse

        if flip_flops[to]
          # Low pulse
          module_map[to].each do |w|
            queue.push([w, LOW_PULSE, to])
          end
        else
          # High pulse
          module_map[to].each do |w|
            queue.push([w, HIGH_PULSE, to])
          end
        end

        flip_flops[to] = !flip_flops[to]
      end

      next unless conjunctions.key?(to)

      conjunctions[to][from] = impulse

      if conjunctions[to].values.all?
        # Low pulse
        module_map[to].each do |w|
          queue.push([w, LOW_PULSE, to])
        end
      else
        # High pulse
        module_map[to].each do |w|
          queue.push([w, HIGH_PULSE, to])
          # Helper for part B
          unless @conjunctions_first_high_pulse.key?(to)
            @conjunctions_first_high_pulse[to] = iteration
          end
        end
      end
    end

    [a, b]
  end
end
