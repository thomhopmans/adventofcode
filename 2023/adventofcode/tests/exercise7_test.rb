require 'minitest/autorun'
require_relative '../exercises/exercise7'

class Exercise6Test < Minitest::Test
  def test_example_a
    assert_equal 6440, Exercise7.new.run_a("32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483")
  end

  def test_example_a_2
    assert_equal 2182, Exercise7.new.run_a("AKATA 640
        QJAAA 902")
  end

  def test_example_a_3
    assert_equal 35, Exercise7.new.run_a("33332 5
        2AAAA 25")
  end

  def test_input_a
    assert_equal 253638586, Exercise7.new.run_a(Exercise7.new.load_data)
  end

  def test_example_b
    assert_equal 5905, Exercise7.new.run_b("32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483")
  end

  def test_hands_with_jokers
    assert_equal [Value::THREE_OF_A_KIND, 1, 1, 5, 4, 8], Hand.new('JJ548', '0', jokers: true).strength
    assert_equal [Value::FIVE_OF_A_KIND, 13, 1, 13, 1, 13], Hand.new('KJKJK', '0', jokers: true).strength
    assert_equal [Value::FOUR_OF_A_KIND, 14, 1, 8, 8, 8], Hand.new('AJ888', '0', jokers: true).strength
    assert_equal [Value::FULL_HOUSE, 3, 9, 3, 9, 1], Hand.new('3939J', '0', jokers: true).strength
    assert_equal [Value::FIVE_OF_A_KIND, 1, 1, 8, 1, 1], Hand.new('JJ8JJ', '0', jokers: true).strength
  end

  def test_input_b
    assert_equal 253253225, Exercise7.new.run_b(Exercise7.new.load_data)
  end
end
