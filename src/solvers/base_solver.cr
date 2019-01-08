require "../model"
require "../solution"

abstract class BaseSolver
  @timeout : Int32 = 100
  @deadline : Time?

  setter :timeout

  def initialize(instance : Instance)
    @instance = instance
  end

  def configure(options : Enumerable({String, String}))
  end

  def solve
    if @timeout
      now = Time.now
      seconds = (@timeout * @instance.tasks.size * 0.99 / 1000).to_i
      span = Time::Span.new(0, 0, 0, seconds)
      @deadline = now + span
    end

    create_solution(schedule)
  end

  def can_continue?
    if @deadline.nil?
      true
    elsif Time.now > @deadline.not_nil!
      false
    else
      true
    end
  end

  def objective(sequence : Enumerable(Schedulable))
    create_solution(sequence).objective
  end

  def create_solution(sequence : Enumerable(Schedulable))
    Solution.new(@instance, sequence)
  end

  abstract def schedule : Enumerable(Schedulable)
end
