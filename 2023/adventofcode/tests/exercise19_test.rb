require 'minitest/autorun'
require_relative '../exercises/exercise19'

class Exercise19Test < Minitest::Test
  INPUT_EXAMPLE = 'px{a<2006:qkq,m>2090:A,rfg}
pv{a>1716:R,A}
lnx{m>1548:A,A}
rfg{s<537:gd,x>2440:R,A}
qs{s>3448:A,lnx}
qkq{x<1416:A,crn}
crn{x>2662:A,R}
in{s<1351:px,qqz}
qqz{s>2770:qs,m<1801:hdj,R}
gd{a>3333:R,R}
hdj{m>838:A,pv}

{x=787,m=2655,a=1222,s=2876}
{x=1679,m=44,a=2067,s=496}
{x=2036,m=264,a=79,s=2244}
{x=2461,m=1339,a=466,s=291}
{x=2127,m=1623,a=2188,s=1013}'.freeze

  def test_example_a
    assert_equal 19114, Exercise19.new.run_a(INPUT_EXAMPLE)
  end

  def test_input_a
    assert_equal 389114, Exercise19.new.run_a(Exercise19.new.load_data)
  end

  def test_example_b
    assert_equal 167409079868000, Exercise19.new.run_b(INPUT_EXAMPLE)
  end

  def test_input_b
    assert_equal 125051049836302, Exercise19.new.run_b(Exercise19.new.load_data)
  end
end
