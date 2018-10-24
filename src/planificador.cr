require "./instance_file"
require "./solvers/greedy_algorithm"

module Planificador
  extend self

  VERSION = "0.1.0"

  def main(path : String, k : Int32, h : Float)
    instance = InstanceFile.new(path).instance(k, h)

    solver = GreedyAlgorithm.new(instance)
    solution = solver.solve

    puts solution.objective
    puts solution.to_s
  end
end

Planificador.main(ARGV[0], ARGV[1].to_i, ARGV[2].to_f)
