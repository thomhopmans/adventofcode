require 'minitest/autorun'
require_relative 'exercise7'

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

  def test_example_b
    assert_equal 5905, Exercise7.new.run_b("32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483")
  end

  def test_hands_with_jokers
    assert_equal 'Three of a Kind', Hand.new('JJ548', '0', jokers: true).rank_name
    assert_equal 'Five of a Kind', Hand.new('KJKJK', '0', jokers: true).rank_name
    assert_equal 'Four of a Kind', Hand.new('AJ888', '0', jokers: true).rank_name
    assert_equal 'Full House', Hand.new('3939J', '0', jokers: true).rank_name
    assert_equal 'Five of a Kind', Hand.new('JJ8JJ', '0', jokers: true).rank_name
  end
end
