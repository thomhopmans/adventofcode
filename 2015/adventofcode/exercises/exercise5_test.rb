require 'minitest/autorun'
require_relative 'exercise5'

class Exercise5Test < Minitest::Test
  def test_a
    assert_equal 1, Exercise5.new.run_a(['ugknbfddgicrmopn'])
    assert_equal 1, Exercise5.new.run_a(['aaa'])
    assert_equal 0, Exercise5.new.run_a(['jchzalrnumimnmhp'])
    assert_equal 0, Exercise5.new.run_a(['haegwjzuvuyypxyu'])
    assert_equal 0, Exercise5.new.run_a(['dvszwmarrgswjxmb'])
  end

  def test_b
    assert_equal 1, Exercise5.new.run_b(['qjhvhtzxzqqjkmpb'])
    assert_equal 1, Exercise5.new.run_b(['xxyxx'])
    assert_equal 0, Exercise5.new.run_b(['uurcxstgmygtbstg'])
    assert_equal 0, Exercise5.new.run_b(['ieodomkazucvgmuy'])
  end
end
