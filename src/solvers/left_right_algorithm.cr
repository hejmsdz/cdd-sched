require "./base_solver"

class LeftRightAlgorithm < BaseSolver
  @start_time : Int32 = 0
  @end_time : Int32 = 0
  @sequence = Deque(Schedulable).new

  def schedule
    tasks = tasks_by_importance
    @start_time = @instance.due_date
    @end_time = @instance.due_date

    tasks.each do |task|
      if @start_time < task.duration || before_cost(task) > after_cost(task)
        add_after(task)
      else
        add_before(task)
      end
    end

    if @start_time > 0
      add_before(Pause.new(@start_time))
    end

    @sequence
  end

  private def tasks_by_importance
    @instance.tasks.sort_by do |task|
      - [task.earliness_penalty, task.tardiness_penalty].max / task.duration.to_f
    end
  end

  private def before_cost(task : Task)
    task.cost(@start_time - task.duration, @instance.due_date)
  end

  private def after_cost(task : Task)
    task.cost(@end_time, @instance.due_date)
  end

  private def add_before(item : Schedulable)
    @sequence.unshift(item)
    @start_time -= item.duration
  end

  private def add_after(item : Schedulable)
    @sequence.push(item)
    @end_time += item.duration
  end
end
