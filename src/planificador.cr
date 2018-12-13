require "./instance_file"
require "./solvers/greedy_algorithm"
require "./solvers/list_algorithm"
require "./solvers/left_right_algorithm"
require "./solvers/simulated_annealing"
require "./solution"

class Planificador
  VERSION = "0.1.0"

  def initialize(args : Array(String))
    @args = args
  end

  def run
    print_solution solve load_instance **parse_arguments
  end

  private def parse_arguments
    { path: @args[0].to_s, k: @args[1].to_i, h: @args[2].to_f }
  rescue IndexError | ArgumentError
    information
  end

  private def load_instance(path : String, k : Int32, h : Float)
    get_instance(instance_file(path), k, h)
  end
    
  private def instance_file(path : String)
    InstanceFile.new(path)
  rescue e : Errno
    error e.message
  rescue ArgumentError
    error "All values in the input file must be integers"
  rescue IndexError
    error "Unexpected end of file"
  end

  private def get_instance(file : InstanceFile, k : Int32, h : Float)
    file.instance(k, h)
  rescue IndexError
    error "Instance file is empty" if file.max_k.zero?
    error "Instance number must be between 1 and #{file.max_k}"
  end

  private def solve(instance : Instance)
    solver = SimulatedAnnealing.new(instance)
    solver.configure(ENV)
    solver.solve
  end

  private def print_solution(solution : Solution)
    puts solution.objective
    puts solution.to_s
  end

  private def information
    puts \
"Usage: #{PROGRAM_NAME} path:string k:int h:float

Source code and more information on:
https://github.com/hejmsdz/planificador

Mikołaj Rozwadowski, 2018
"
    exit
  end

  private def error(message : String?)
    STDERR.puts message || "An error occurred"
    exit 1
  end
end

Planificador.new(ARGV).run
