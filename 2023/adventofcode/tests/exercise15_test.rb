require 'minitest/autorun'
require_relative '../exercises/exercise15'

class Exercise15Test < Minitest::Test
  INPUT_EXAMPLE = 'rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7'.freeze

  def test_example_a
    assert_equal 1320, Exercise15.new.run_a(INPUT_EXAMPLE)
  end

  def test_example_a_hash
    assert_equal 52, Exercise15.new.hash('HASH')
  end

  def test_input_a
    assert_equal 515210, Exercise15.new.run_a(Exercise15.new.load_data)
  end

  def test_example_b
    assert_equal 145, Exercise15.new.run_b(INPUT_EXAMPLE)
  end

  def test_input_b
    assert_equal 246762, Exercise15.new.run_b(Exercise15.new.load_data)
  end
end
