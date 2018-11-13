abstract class Schedulable
  abstract def duration : Int32
  abstract def cost(start_time : Int32, due_date : Int32) : Int32
end

class Task < Schedulable
  getter id : Int32
  getter duration : Int32
  getter earliness_penalty : Int32
  getter tardiness_penalty : Int32

  def initialize(id : Int32, duration : Int32, earliness_penalty : Int32, tardiness_penalty : Int32)
    @id = id
    @duration = duration
    @earliness_penalty = earliness_penalty
    @tardiness_penalty = tardiness_penalty
  end

  def cost(start_time : Int32, due_date : Int32)
    completion = start_time + @duration
    lateness = completion - due_date
    [lateness, 0].max * @tardiness_penalty - [lateness, 0].min * @earliness_penalty
  end

  def to_s(io : IO)
    io << "t#{@id}"
  end
end

class Pause < Schedulable
  getter duration : Int32

  def initialize(duration : Int32)
    @duration = duration
  end

  def to_s(io : IO)
    io << "p#{@duration}"
  end

  def cost(start_time : Int32, due_date : Int32)
    0
  end
end

class Instance
  getter tasks : Enumerable(Task)
  getter h : Float64
  getter due_date : Int32

  def initialize(tasks : Enumerable(Task), h : Float64)
    @tasks = tasks
    @h = h
    @due_date = calculate_due_date
  end

  def calculate_due_date
    total_duration = tasks.map(&.duration).sum
    (total_duration * h).to_i
  end
end
