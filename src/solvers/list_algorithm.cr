require "./base_solver"

class ListAlgorithm < BaseSolver
  def schedule
    due_factor = (@instance.h - 0.5) * 2
    tasks = @instance.tasks.sort_by do |task|
      task.earliness_penalty - task.tardiness_penalty
    end

    sequence = [] of Schedulable
    sequence.concat(tasks)
  end
end
