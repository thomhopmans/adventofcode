require 'minitest/autorun'
require_relative '../exercises/exercise1'

class Exercise1Test < Minitest::Test
  def test_example_results_in_floor_0
    assert_equal 0, Exercise01.new.run_a('(())')
    assert_equal 0, Exercise01.new.run_a('()()')
  end

  def test_example_results_in_floor_3
    assert_equal 3, Exercise01.new.run_a('(((')
    assert_equal 3, Exercise01.new.run_a('(()(()(')
    assert_equal 3, Exercise01.new.run_a('))(((((')
  end

  def test_example_results_in_floor_minus1
    assert_equal(-1, Exercise01.new.run_a('())'))
    assert_equal(-1, Exercise01.new.run_a('))('))
  end

  def test_example_results_in_floor_minus3
    assert_equal(-3, Exercise01.new.run_a(')))'))
    assert_equal(-3, Exercise01.new.run_a(')())())'))
  end

  def test_example_reaches_floor_minus_1_at_position_5
    assert_equal 1, Exercise01.new.run_b(')')
    assert_equal 5, Exercise01.new.run_b('()())')
  end
end
