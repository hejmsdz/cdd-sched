require "./model"

class Solution
  def initialize(instance : Instance, sequence : Enumerable(Schedulable))
    @instance = instance
    @sequence = sequence
  end

  def objective : Int32
    time = 0
    cost = 0

    @sequence.each do |item|
      cost += item.cost(time, @instance.due_date)
      time += item.duration
    end
    cost
  end

  def to_s(io : IO)
    io << @sequence.map(&.to_s).join(' ')
  end
end
