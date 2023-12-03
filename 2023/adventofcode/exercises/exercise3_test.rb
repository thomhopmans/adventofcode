require 'minitest/autorun'
require_relative 'exercise3'

class Exercise3Test < Minitest::Test
  def test_example_a
    assert_equal 4361, Exercise3.new.run_a(['467..114..',
                                            '...*......',
                                            '..35..633.',
                                            '......#...',
                                            '617*......',
                                            '.....+.58.',
                                            '..592.....',
                                            '......755.',
                                            '...$.*....',
                                            '.664.598..'])
  end

  def test_example_b
    assert_equal 467835, Exercise3.new.run_b(['467..114..',
                                              '...*......',
                                              '..35..633.',
                                              '......#...',
                                              '617*......',
                                              '.....+.58.',
                                              '..592.....',
                                              '......755.',
                                              '...$.*....',
                                              '.664.598..'])
  end
end
