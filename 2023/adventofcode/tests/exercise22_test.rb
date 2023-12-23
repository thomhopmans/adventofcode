require 'minitest/autorun'
require_relative '../exercises/exercise22'

class Exercise22Test < Minitest::Test
  INPUT_EXAMPLE = '1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9'.freeze

  def test_example_a
    assert_equal 5, Exercise22.new.run_a(INPUT_EXAMPLE)
  end

  def test_input_a
    assert_equal 432, Exercise22.new.run_a(Exercise22.new.load_data)
  end

  def test_example_b
    assert_equal 7, Exercise22.new.run_b(INPUT_EXAMPLE)
  end

  def test_input_b
    assert_equal 63166, Exercise22.new.run_b(Exercise22.new.load_data)
  end
end
