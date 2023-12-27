require 'minitest/autorun'
require_relative '../exercises/exercise25'

class Exercise25Test < Minitest::Test
  INPUT_EXAMPLE = 'jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr'.freeze

  def test_example_a
    assert_equal 54, Exercise25.new.run_a(INPUT_EXAMPLE)
  end

  def test_input_a
    assert_equal 568214, Exercise25.new.run_a(Exercise25.new.load_data)
  end
end
