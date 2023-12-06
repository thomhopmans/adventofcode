require 'minitest/autorun'
require_relative 'exercise6'

class Exercise6Test < Minitest::Test
  def test_example_a
    assert_equal 288, Exercise6.new.run_a("Time:      7  15   30
Distance:  9  40  200")
  end

  def test_example_b
    assert_equal 71503, Exercise6.new.run_b("Time:      7  15   30
      Distance:  9  40  200")
  end
end
