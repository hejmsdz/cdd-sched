require "./base_solver"

class GreedyAlgorithm < BaseSolver
  def schedule
    sequence = [] of Schedulable
    tasks_left = Set.new(@instance.tasks)

    time = 0
    while tasks_left.any?
      cheapest_task = tasks_left.min_by do |task|
        task.cost(time, @instance.due_date)
      end
      tasks_left.delete(cheapest_task)
      sequence << cheapest_task
      time += cheapest_task.duration
    end

    sequence
  end
end
