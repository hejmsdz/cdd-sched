require "../model"
require "../solution"

abstract class BaseSolver
  def initialize(instance : Instance)
    @instance = instance
  end

  def configure(options : Enumerable({String, String}))
  end

  def solve
    create_solution(schedule)
  end

  def objective(sequence : Enumerable(Schedulable))
    create_solution(sequence).objective
  end

  def create_solution(sequence : Enumerable(Schedulable))
    Solution.new(@instance, sequence)
  end

  abstract def schedule : Enumerable(Schedulable)
end
