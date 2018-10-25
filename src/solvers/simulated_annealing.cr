require "./base_solver"

class SimulatedAnnealing < BaseSolver
  @temperature : Float32 = 10000.0
  @cooling_rate : Float32 = 0.03

  def schedule
    current_sequence = random_sequence
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

  def random_sequence
    sequence = [] of Schedulable
    @instance.tasks.shuffle.each do |task|
      sequence << task
    end
    sequence
  end

  def modify(sequence)
    index1 = Random.rand(sequence.size)
    index2 = Random.rand(sequence.size)
    sequence.dup.swap(index1, index2)
  end
end
