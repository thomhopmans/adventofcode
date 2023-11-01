require 'minitest/autorun'
require_relative 'exercise2'

class Exercise2Test < Minitest::Test
  def test_example_results_in_correct_wrapping_paper
    assert_equal 58, Exercise2.new.run_a(['2x3x4'])
    assert_equal 43, Exercise2.new.run_a(['1x1x10'])
  end

  def test_example_results_in_correct_ribbon_length
    assert_equal 34, Exercise2.new.run_b(['2x3x4'])
    assert_equal 14, Exercise2.new.run_b(['1x1x10'])
  end
end
