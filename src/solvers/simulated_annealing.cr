require "./base_solver"
require "./left_right_algorithm"

class SimulatedAnnealing < BaseSolver
  @initial_temperature : Float32 = 10000.0
  @temperature : Float32 = 0
  @cooling_rate : Float32 = 0.005

  def configure(options)
    @initial_temperature = options["TEMPERATURE"].to_f32 if options.has_key?("TEMPERATURE")
    @cooling_rate = options["COOLING_RATE"].to_f32 if options.has_key?("COOLING_RATE")
  end

  def schedule
    sequence = simple_heuristic_solution
    objective_value = objective(sequence)

    loop do
      new_sequence = iterate(sequence, objective_value)
      new_objective_value = objective(new_sequence)

      if sequence.nil? || new_objective_value < objective_value.not_nil!
        sequence = new_sequence
        objective_value = new_objective_value
      end

      @cooling_rate *= 0.9

      break unless can_continue?
    end

    sequence.not_nil!
  end

  def iterate(initial_sequence, initial_objective)
    current_sequence = initial_sequence
    current_objective = initial_objective

    @temperature = @initial_temperature

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

  def simple_heuristic_solution
    LeftRightAlgorithm.new(@instance).schedule
  end

  def modify(sequence)
    index1 = Random.rand(sequence.size)
    index2 = Random.rand(sequence.size)
    sequence.dup.swap(index1, index2)
  end
end
