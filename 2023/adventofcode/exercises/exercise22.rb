require_relative 'helpers/exercise'
require 'lazy_priority_queue'

class Brick
  attr_accessor :start, :end, :floor, :height

  # @param support blocks below [Array<Brick>]
  attr_accessor :support_below

  # @param support_above blocks above [Array<Brick>]
  attr_accessor :support_above

  def initialize(start, ends)
    @start = start
    @end = ends
    @floor = [@start[2], @end[2]].min
    @height = (@start[2] - @end[2]).abs
    @support_below = []
    @support_above = []
  end

  def xy_overlap?(brick)
    @start[0] <= brick.end[0] \
    && @end[0] >= brick.start[0] \
    && @start[1] <= brick.end[1] \
    && @end[1] >= brick.start[1]
  end
end

class Exercise22 < Exercise
  EXERCISE_NUMBER = 22

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    bricks, floor_level = parse(data)
    stable_bricks = stabilize_bricks(bricks, floor_level)
    safe_disintegrated_bricks(stable_bricks)
  end

  def run_b(data)
    bricks, floor_level = parse(data)
    stable_bricks = stabilize_bricks(bricks, floor_level)
    max_falling_bricks(stable_bricks)
  end

  private

  def parse(data)
    bricks = MinPriorityQueue.new
    lowest_level = nil

    data.split("\n").each do |d|
      start, ends = d.split('~').map { |v| v.split(',').map(&:to_i) }
      brick = Brick.new(start, ends)
      bricks.push(brick, brick.floor)
      lowest_level = brick.floor if lowest_level.nil? || lowest_level > brick.floor
    end

    [bricks, lowest_level]
  end

  def safe_disintegrated_bricks(stable_bricks)
    stable_bricks.map do |stable_brick|
      if stable_brick.support_above.empty? || stable_brick.support_above.all? { |s| s.support_below.size > 1 }
        1
      end
    end.compact.sum
  end

  def max_falling_bricks(stable_bricks)
    stable_bricks.map do |stable_brick|
      fall_stack = stable_brick.support_above.select { |s| s.support_below.size == 1 }
      fallen = Set.new
      until fall_stack.empty?
        falling_brick = fall_stack.shift
        fallen << falling_brick
        fall_stack.concat(falling_brick.support_above.select { |s| (s.support_below.to_set - fallen).empty? })
      end

      fallen.size
    end.sum
  end

  def stabilize_bricks(bricks, floor_level)
    stable_bricks = []
    until bricks.empty?
      brick = bricks.pop # Take from lowest floor

      # Bricks on floor level are per definition stable
      if brick.floor == floor_level
        stable_bricks << brick
        next
      end

      # Find stable position of current brick
      support_below = []
      support_level = 0

      # Check if there are existing stable bricks below current brick
      stable_bricks.each do |stable_brick|
        next unless stable_brick.xy_overlap?(brick)

        stable_brick_top = stable_brick.floor + stable_brick.height
        if stable_brick_top > support_level
          support_below = []
          support_level = stable_brick_top
        end
        support_below << stable_brick if stable_brick_top == support_level
      end

      # Upate floor level of brick and add support bricks below
      brick.support_below = support_below
      brick.floor = support_level + 1
      stable_bricks << brick

      # Update supporting blocks below with the current new brick on top
      support_below.each do |s_brick|
        s_brick.support_above << brick
      end
    end

    stable_bricks
  end
end
