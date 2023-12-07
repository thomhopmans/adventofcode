require 'minitest/autorun'
require_relative 'exercise6'

class Exercise6Test < Minitest::Test
  def test_example_a
    assert_equal 288, Exercise6.new.run_a("Time:      7  15   30
Distance:  9  40  200")
  end

  def test_input_a
    assert_equal 2065338, Exercise6.new.run_a(Exercise6.new.load_data)
  end

  def test_example_b
    assert_equal 71503, Exercise6.new.run_b("Time:      7  15   30
      Distance:  9  40  200")
  end

  def test_input_b
    assert_equal 34934171, Exercise6.new.run_b(Exercise6.new.load_data)
  end
end
