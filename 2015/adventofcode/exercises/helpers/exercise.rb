class Exercise
  EXERCISE_NUMBER = nil

  def load_data
    File.read("#{__dir__}/../../inputs/exercise#{self.class::EXERCISE_NUMBER}.txt")
  end
end
