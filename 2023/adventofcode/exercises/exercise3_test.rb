require 'minitest/autorun'
require_relative 'exercise3'

class Exercise3Test < Minitest::Test
  def test_example_a
    assert_equal 8, Exercise3.new.run_a(['foo'])
  end

  # def test_example_b
  #   assert_equal 8, Exercise3.new.run_b(['foo'])
  # end
end
