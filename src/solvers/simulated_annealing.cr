require "./base_solver"
require "./left_right_algorithm"

class SimulatedAnnealing < BaseSolver
  @temperature : Float32 = 10000.0
  @cooling_rate : Float32 = 0.005
  @iterations : Int32 = 1

  def configure(options)
    @temperature = options["TEMPERATURE"].to_f32 if options.has_key?("TEMPERATURE")
    @cooling_rate = options["COOLING_RATE"].to_f32 if options.has_key?("COOLING_RATE")
    @iterations = options["ITERATIONS"].to_i if options.has_key?("ITERATIONS")
  end

  def schedule
    (0...@iterations).map { iterate }.min_by { |sequence| objective(sequence) }
  end

  def iterate
    current_sequence = initial_sequence
    current_objective = objective(current_sequence)

    while @temperature > 1
      new_sequence = modify(current_sequence)
      new_objective = objective(new_sequence)

      if Random.rand < switch_probability(current_objective, new_objective)
        current_sequence = new_sequence
        current_objective = new_objective
      end

      @temperature *= (1 - @cooling_rate)
    end

    current_sequence
  end

  def switch_probability(current_energy : Number, new_energy : Number) : Float32
    Math.exp((current_energy - new_energy) / @temperature)
  end

  def initial_sequence
    LeftRightAlgorithm.new(@instance).schedule
  end

  def modify(sequence)
    index1 = Random.rand(sequence.size)
    index2 = Random.rand(sequence.size)
    sequence.dup.swap(index1, index2)
  end
end
