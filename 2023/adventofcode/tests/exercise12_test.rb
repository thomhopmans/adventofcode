require 'minitest/autorun'
require_relative '../exercises/exercise12'

class Exercise12Test < Minitest::Test
  INPUT_EXAMPLE = '???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1'.freeze

  def test_example_a
    assert_equal 21, Exercise12.new.run_a(INPUT_EXAMPLE)
  end

  def test_example_a_individual
    assert_equal 1, Exercise12.new.run_a('???.### 1,1,3')
    assert_equal 4, Exercise12.new.run_a('.??..??...?##. 1,1,3')
    assert_equal 1, Exercise12.new.run_a('?#?#?#?#?#?#?#? 1,3,1,6')
    assert_equal 1, Exercise12.new.run_a('????.#...#... 4,1,1')
    assert_equal 4, Exercise12.new.run_a('????.######..#####. 1,6,5')
    assert_equal 10, Exercise12.new.run_a('?###???????? 3,2,1')
  end

  def test_input_a
    assert_equal 7402, Exercise12.new.run_a(Exercise12.new.load_data)
  end

  def test_example_b
    assert_equal 525152, Exercise12.new.run_b(INPUT_EXAMPLE)
  end

  def test_example_b_individual
    assert_equal 1, Exercise12.new.run_b('???.### 1,1,3')
    assert_equal 16384, Exercise12.new.run_b('.??..??...?##. 1,1,3')
    assert_equal 1, Exercise12.new.run_b('?#?#?#?#?#?#?#? 1,3,1,6')
    assert_equal 16, Exercise12.new.run_b('????.#...#... 4,1,1')
    assert_equal 2500, Exercise12.new.run_b('????.######..#####. 1,6,5')
    assert_equal 506250, Exercise12.new.run_b('?###???????? 3,2,1')
  end

  def test_input_b
    assert_equal 3384337640277, Exercise12.new.run_b(Exercise12.new.load_data)
  end
end
