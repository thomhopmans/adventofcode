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
    flip_flops, conjunctions = parse_cables(data)

    output = (1..1000).map do |iteration|
      push_button(iteration, flip_flops, conjunctions)
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
    flip_flops, conjunctions = parse_cables(data)

    # 4080 is exactly sufficient for my input
    (1..4080).map do |iteration|
      push_button(iteration, flip_flops, conjunctions)
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
    @module_map = {}

    data.split("\n").map do |line|
      name, where = line.split(' -> ')

      if name[0] == '%'
        flip_flops[name[1..-1]] = false
        @module_map[name[1..-1]] = where.split(', ')
        next
      end

      if name[0] == '&'
        conjunctions[name[1..-1]] = {}
        @module_map[name[1..-1]] = where.split(', ')
        next
      end

      @module_map[name] = where.split(', ')
    end

    conjunctions.each_key do |c|
      @module_map.each do |name, where|
        conjunctions[c][name] = false if where.include?(c)
      end
    end

    @module_map.freeze
    @conjunctions_first_high_pulse = Hash.new(0) # Helper for part B

    [flip_flops, conjunctions] # State
  end

  def push_button(iteration, flip_flops, conjunctions)
    queue = []
    a = 0
    b = 1

    broadcast_initial_signal(queue)

    # Process all cables
    until queue.empty?
      to, impulse, from = queue.shift

      a += 1 if impulse == HIGH_PULSE
      b += 1 if impulse != HIGH_PULSE

      process_flip_flops(to, impulse, flip_flops, queue)
      process_conjunctions(to, from, impulse, conjunctions, iteration, queue)
    end

    [a, b]
  end

  def broadcast_initial_signal(queue)
    @module_map['broadcaster'].each { |w| queue.push([w, LOW_PULSE, 'broadcaster']) }
  end

  def process_flip_flops(to, impulse, flip_flops, queue)
    return unless flip_flops.key?(to) && !impulse

    pulse_type = flip_flops[to] ? LOW_PULSE : HIGH_PULSE
    @module_map[to].each { |w| queue.push([w, pulse_type, to]) }
    flip_flops[to] = !flip_flops[to]
  end

  def process_conjunctions(to, from, impulse, conjunctions, iteration, queue)
    return unless conjunctions.key?(to)

    conjunctions[to][from] = impulse
    pulse_type = conjunctions[to].values.all? ? LOW_PULSE : HIGH_PULSE

    @module_map[to].each do |w|
      queue.push([w, pulse_type, to])
      @conjunctions_first_high_pulse[to] = iteration unless @conjunctions_first_high_pulse.key?(to) || pulse_type == LOW_PULSE
    end
  end
end
