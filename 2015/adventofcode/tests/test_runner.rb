require 'minitest/autorun'

# Find all test files in the 'tests' directory
Dir.glob('./adventofcode/tests/*_test.rb').sort.each { |file| require file }
