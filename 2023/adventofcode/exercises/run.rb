# Get the argument passed when running the script
input_argument = ARGV[0]
input_argument = '*' if ARGV[0].nil?

# Load all Ruby files from the 'exercises' folder
Dir["./adventofcode/exercises/exercise#{input_argument}.rb"].each do |file|
  require file
end

# Get all Exercise classes from loaded files, and sort by day
classes = ObjectSpace.each_object(Class).filter_map do |cls|
  [cls.name, cls] if cls.name&.start_with?('Exercise')
end.sort.map { _1[1] }

# Initialize each class and call the 'run' method
classes.each do |cls|
  instance = cls.new if cls.respond_to?(:new)
  instance.run if instance.respond_to?(:run)
end
