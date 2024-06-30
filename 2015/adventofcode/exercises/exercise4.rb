require 'digest'
require_relative 'helpers/exercise'

class Exercise04 < Exercise
  EXERCISE_NUMBER = 4

  def run
    puts "Exercise #{self.class::EXERCISE_NUMBER}:"
    puts "A: #{run_a(load_data)}"
    puts "B: #{run_b(load_data)}"
  end

  def run_a(secret_key)
    find(secret_key, '00000')
  end

  def run_b(secret_key)
    find(secret_key, '000000')
  end

  def find(secret_key, prefix)
    number = 0
    md5_hash = ''

    while md5_hash.start_with?(prefix) == false do
      number += 1
      input_string = "#{secret_key}#{number}"
      md5_hash = Digest::MD5.hexdigest(input_string)
    end

    number
  end
end
