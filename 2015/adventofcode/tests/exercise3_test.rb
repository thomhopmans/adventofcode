require 'minitest/autorun'
require_relative '../exercises/exercise3'

class Exercise3Test < Minitest::Test
  def test_route_returns_unique_visited_houses
    assert_equal 2, Exercise03.new.run_a('>')
    assert_equal 4, Exercise03.new.run_a('^>v<')
    assert_equal 2, Exercise03.new.run_a('^v^v^v^v^v')
  end

  def test_route_with_robo_santa_returns_unique_visited_houses
    assert_equal 3, Exercise03.new.run_b('>v')
    assert_equal 3, Exercise03.new.run_b('^>v<')
    assert_equal 11, Exercise03.new.run_b('^v^v^v^v^v')
  end
end
