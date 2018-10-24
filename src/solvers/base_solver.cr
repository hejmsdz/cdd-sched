require "../model"
require "../solution"

abstract class BaseSolver
  def initialize(instance : Instance)
    @instance = instance
  end

  def solve
    Solution.new(@instance, schedule)
  end

  abstract def schedule : Enumerable(Schedulable)
end
