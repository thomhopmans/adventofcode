require 'minitest/autorun'
require_relative 'exercise4'

class Exercise4Test < Minitest::Test
  def test_secret_key_returns_lowest_positive_number_with_md5_hash_match
    assert_equal 609043, Exercise4.new.run_a('abcdef')
    assert_equal 1048970, Exercise4.new.run_a('pqrstuv')
  end
end
