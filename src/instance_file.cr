require "./model"

class InstanceFile
  def initialize(path : String)
    @path = path
    @task_sets = [] of Array(Task)
    load
  end

  def instance(k : Int32, h : Float)
    tasks = @task_sets[k - 1]
    total_duration = tasks.map(&.duration).sum
    due_date = (total_duration * h).to_i
    Instance.new(tasks, due_date)
  end

  private def load
    stream = read_numbers
    num_task_sets = stream.shift
    @task_sets = (0...num_task_sets).map do
      num_tasks = stream.shift
      (0...num_tasks).map do |i|
        Task.new(i, stream.shift, stream.shift, stream.shift)
      end
    end
  end

  private def read_numbers : Deque(Int32)
    numbers = Deque(Int32).new
    File.each_line(@path) do |line|
      line.split.map(&.to_i).each do |number|
        numbers.push(number)
      end
    end
    numbers
  end
end
