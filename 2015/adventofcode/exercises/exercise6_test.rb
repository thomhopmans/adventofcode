require 'minitest/autorun'
require_relative 'exercise6'

class Exercise6Test < Minitest::Test
  def test_a
    assert_equal 1_000_000, Exercise6.new.run_a(['turn on 0,0 through 999,999'])
    assert_equal 1_000, Exercise6.new.run_a(['toggle 0,0 through 999,0'])
    assert_equal 0, Exercise6.new.run_a(['turn off 499,499 through 500,500'])
  end

  def test_b
    # assert_equal 3, Exercise6.new.run_b('>v')
  end
end
