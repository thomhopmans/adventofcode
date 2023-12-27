require 'minitest/autorun'
require_relative '../exercises/exercise24'

class Exercise24Test < Minitest::Test
  INPUT_EXAMPLE = '19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3'.freeze

  def test_example_a
    assert_equal 2, Exercise24.new.run_a(INPUT_EXAMPLE, min_value: 7, max_value: 27)
  end

  def test_input_a
    assert_equal 12343, Exercise24.new.run_a(Exercise24.new.load_data)
  end

  def test_example_b
    assert_equal 47, Exercise24.new.run_b(INPUT_EXAMPLE)
  end

  def test_input_b
    assert_equal 769281292688187, Exercise24.new.run_b(Exercise24.new.load_data)
  end
end
