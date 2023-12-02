require 'minitest/autorun'
require_relative 'exercise1'

class Exercise1Test < Minitest::Test
  def test_example_a
    assert_equal 12, Exercise1.new.run_a(['1abc2'])
    assert_equal 38, Exercise1.new.run_a(['pqr3stu8vwx'])
    assert_equal 15, Exercise1.new.run_a(['a1b2c3d4e5f'])
    assert_equal 77, Exercise1.new.run_a(['treb7uchet'])
  end

  def test_example_b
    assert_equal 83, Exercise1.new.run_b(['eightwothree'])
    assert_equal 88, Exercise1.new.run_b(['eightavsdfsdfsd'])
    assert_equal 88, Exercise1.new.run_b(['avsdfsdfsd8'])
  end

  def test_example_b_full
    assert_equal 281, Exercise1.new.run_b(['two1nine',
                                           'eightwothree',
                                           'abcone2threexyz',
                                           'xtwone3four',
                                           '4nineeightseven2',
                                           'zoneight234',
                                           '7pqrstsixteen'])
  end
end
