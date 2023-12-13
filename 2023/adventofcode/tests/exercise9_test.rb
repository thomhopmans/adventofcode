require 'minitest/autorun'
require_relative '../exercises/exercise9'

class Exercise09Test < Minitest::Test
  def test_example_a
    assert_equal 114, Exercise09.new.run_a("0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45")
  end

  def test_input_a
    assert_equal 1584748274, Exercise09.new.run_a(Exercise09.new.load_data)
  end

  def test_example_b
    assert_equal 2, Exercise09.new.run_b("0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45")
  end

  def test_input_b
    assert_equal 1026, Exercise09.new.run_b(Exercise09.new.load_data)
  end
end
