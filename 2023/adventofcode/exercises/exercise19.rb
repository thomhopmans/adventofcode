require_relative 'helpers/exercise'

CATEGORIES = %w[x m a s].freeze

class Exercise19 < Exercise
  EXERCISE_NUMBER = 19

  NO_RANGE = nil

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(data)
    workflows, parts = parse(data)
    calculate_total_rating(workflows, parts)
  end

  def run_b(data)
    workflows, = parse(data)
    accepted_workflows = workflows_leading_to_accepted_parts(workflows)
    total_distinct_combinations(accepted_workflows)
  end

  private

  def parse(data)
    workflows_str, parts_str = data.split("\n\n")

    workflows = {}
    workflows_str.split("\n").each do |wf|
      name = wf.match(/\A[^{]*/)[0]
      workflows[name] = {}

      wf.match(/\{(.*?)\}/)[1].split(',').each do |rule|
        if rule.include?('<') || rule.include?('>')
          sign = (rule.include?('<') ? '<' : '>')
          category, threshold, to_workflow = rule.split(/<|>|:/)
          workflows[name][[category, sign, threshold.to_i]] = to_workflow
        else
          workflows[name][NO_RANGE] = rule
        end
      end
    end

    parts = parts_str.split("\n").map { |line| CATEGORIES.zip(line.scan(/\d+/).map(&:to_i)).to_h }

    [workflows, parts]
  end

  def calculate_total_rating(workflows, parts)
    total_rating = 0

    parts.each do |part|
      workflow_name = 'in'
      while workflow_name
        break if workflow_name == 'R'

        if workflow_name == 'A'
          total_rating += part.values.sum
          break
        end

        workflows[workflow_name].each do |rule, next_workflow_name|
          (category, sign, threshold) = rule
          if rule == NO_RANGE || meets_rule?(part[category], sign, threshold)
            workflow_name = next_workflow_name
            break
          end
        end
      end
    end

    total_rating
  end

  def meets_rule?(x, sign, y)
    sign == '<' ? x < y : x > y
  end

  def workflows_leading_to_accepted_parts(workflows)
    accepted = []
    queue = [
      [['in'], []],
    ]

    until queue.empty?
      full_workflow, conditions = queue.shift

      if full_workflow.last == 'A'
        accepted.push([full_workflow, conditions])
        next
      elsif full_workflow.last == 'R'
        next
      end

      workflows[full_workflow.last].each do |cond, name|
        next_conditions = conditions.clone
        next_workflow = full_workflow + [name]

        unless cond == NO_RANGE
          next_conditions.push(cond)
          x, sign, y = *cond
          conditions.push(flip_rule_sign(x, sign, y))
        end

        queue.push([next_workflow, next_conditions])
      end
    end

    accepted
  end

  def flip_rule_sign(x, sign, y)
    sign == '>' ? [x, '<=', y] : [x, '>=', y]
  end

  def total_distinct_combinations(accepted_workflows)
    accepted_workflows.map do |_, conditions|
      distinct_combinations_in_workflow(conditions)
    end.sum
  end

  def distinct_combinations_in_workflow(conditions)
    category_ranges = CATEGORIES.map { |key| [key, [1, 4000]] }.to_h
    conditions.each do |type, sign, val|
      case sign
        when '>'
          category_ranges[type][0] = val + 1
        when '>='
          category_ranges[type][0] = val
        when '<'
          category_ranges[type][1] = val - 1
        when '<='
          category_ranges[type][1] = val
      end
    end
    category_ranges.values.map { |k| k[1] - k[0] + 1 }.reduce(:*)
  end
end
