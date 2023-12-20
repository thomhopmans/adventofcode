require 'minitest/autorun'
require_relative '../exercises/exercise20'

class Exercise20Test < Minitest::Test
  INPUT_EXAMPLE_1 = 'broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a'.freeze

  INPUT_EXAMPLE_2 = 'broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output'.freeze

  def test_example_a_1
    assert_equal 32000000, Exercise20.new.run_a(INPUT_EXAMPLE_1)
  end

  def test_example_a_2
    assert_equal 11687500, Exercise20.new.run_a(INPUT_EXAMPLE_2)
  end

  def test_input_a
    assert_equal 731517480, Exercise20.new.run_a(Exercise20.new.load_data)
  end

  def test_input_b
    assert_equal 244178746156661, Exercise20.new.run_b(Exercise20.new.load_data)
  end
end
