class Exercise3
  DIRECTIONS = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 0],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1],
  ]

  def run
    puts 'Exercise 3:'
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(instructions)
    engine_digits = []

    scan_row_index = 0
    while scan_row_index < instructions.size
      line = instructions[scan_row_index]
      scan_char_index = 0

      while scan_char_index < line.size
        char_at_pos = line[scan_char_index]
        found_digit = ''

        if digit?(char_at_pos)
          eligible_digit = false

          # Extract digit and possigible hit
          while digit?(line[scan_char_index])
            # Get digit value
            char_at_pos = line[scan_char_index]
            found_digit += char_at_pos

            # Hits around digit?
            if symbol_around?(instructions, scan_row_index, scan_char_index)
              eligible_digit = true
            end

            # Next char
            scan_char_index += 1
          end

          # Full eligible digit found
          engine_digits.append(found_digit.to_i) if eligible_digit
        else
          scan_char_index += 1
        end
      end

      scan_row_index += 1
    end

    engine_digits.sum
  end

  def symbol_around?(instructions, row_index, char_index)
    found_symbol = false

    DIRECTIONS.each do |d|
      other_char_index = char_index + d[0]
      other_row_index = row_index + d[1]

      next unless (other_char_index >= 0 && other_char_index < instructions[0].size) && (other_row_index >= 0 && other_row_index < instructions.size)

      other_char = instructions[other_row_index][other_char_index]

      if not_digit_or_dot?(other_char)
        found_symbol = true
      end
    end

    found_symbol
  end

  def digit?(char)
    return false if char.nil?

    !!char.match(/\A\d\z/)
  end

  def not_digit_or_dot?(char)
    return false if char.nil?

    !/[\d.]/.match?(char)
  end

  def run_b(instructions)
    gear_digits_map = {}

    scan_row_index = 0
    while scan_row_index < instructions.size
      line = instructions[scan_row_index]
      scan_char_index = 0

      while scan_char_index < line.size
        char_at_pos = line[scan_char_index]
        found_digit = ''

        if digit?(char_at_pos)
          digit_gear_symbols = []

          # Extract full digit and surrounding gears
          while digit?(line[scan_char_index])
            # Get digit value
            char_at_pos = line[scan_char_index]
            found_digit += char_at_pos

            # Surrounding gear symbols
            gear_symbols = surrounding_gear_symbols(instructions, scan_row_index, scan_char_index)
            gear_symbols.each do |x|
              unless digit_gear_symbols.include?(x)
                digit_gear_symbols.append(x)
              end
            end

            # Next character in digit
            scan_char_index += 1
          end

          # Found full digit
          found_digit = found_digit.to_i

          # Map from digit->gears to gear->digits
          digit_gear_symbols.each do |x|
            if gear_digits_map.keys.include?(x)
              gear_digits_map[x].append(found_digit)
            else
              gear_digits_map[x] = [found_digit]
            end
          end

        else
          scan_char_index += 1
        end
      end

      scan_row_index += 1
    end

    # Filter for all keys (gears) that are adjacent to exactly two part numbers
    # And calculate the sum over all gear ratios
    gear_digits_map.select { |_key, value| value.size == 2 }.map { |_key, value| value[0] * value[1] }.sum
  end

  def surrounding_gear_symbols(instructions, row_index, char_index)
    found_symbols = []

    DIRECTIONS.each do |d|
      other_char_index = char_index + d[0]
      other_row_index = row_index + d[1]

      next unless (other_char_index >= 0 && other_char_index < instructions[0].size) && (other_row_index >= 0 && other_row_index < instructions.size)

      other_char = instructions[other_row_index][other_char_index]

      if other_char == '*'
        found_symbols.append([other_row_index, other_char_index])
      end
    end

    found_symbols
  end

  def load_data
    File.read("#{__dir__}/../inputs/exercise3.txt").split("\n")
  end
end

Exercise3.new.run
