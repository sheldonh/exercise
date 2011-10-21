# Represents a programming exercise, composed of string representations of code that sets up a starting context and defines
# a final goal, and allows candidate solutions to the problem to be tested with with #solve method.
#
# For example:
#
#   exercise = Exercise.new "a = 1; b = 2", "c == 3"
#   exercise.solve "c = a * b" # => false
#   exercise.solve "c = a + b" # => true
class Exercise

  # If called without a block, the context code and goal code may be passed as string arguments, .e.g
  #
  #   Exercise.new "a = rand(10); b = rand(10)", "c == a + b"
  #
  # Alternatively, a block may be used to produce more readable initialization of exercises with larger contexts or goals, e.g.
  #
  #   Exercise.new do |e|
  #     e.context %q{
  #       a = rand(10)
  #       b = rand(10)
  #       orig = { :a => a, :b => b }
  #     }
  #     e.goal %q{
  #       a == orig[:b]
  #       b == orig[:a]
  #     }
  #   end
  def initialize(*args)
    if block_given?
      yield self
    else
      context args[0]
      goal args[1]
    end
  end

  # Sets or returns the string representation of the exercise's initial context code. The context is the first code evaluated
  # by the #solve method. Leading and trailing newline characters are stripped.
  def context(context = nil)
    @context = newline_strip(context) if context
    @context
  end

  # Sets or returns the string representation of the exercise's final goal code. The goal is the last code evaluated
  # by the #solve method, and should evaluate to true if the solution code solves the problem, and false otherwise. Leading and
  # trailing newline characters are stripped.
  def goal(goal = nil)
    @goal = newline_strip(goal) if goal
    @goal
  end

  # Takes a string representation of code that provides a candidate solution, then evaluates the context, solution and goal
  # code (in that order) in a high safety level thread and returns true if the goal was achieved. If any evaluated code raises
  # an exception, false is returned. In other words, the cause of failure is completely opaque to the caller.
  def solve(solution)
    safety_thread { |scope| scope.eval "#{context}\n#{solution}\n#{goal}" }
    rescue Exception
      false
  end

  private

  # Creates a thread in which the Ruby $SAFE level is set to 4, inside which a tainted scope (binding) is passed into the given
  # block. This allows the block to evaluate code inside the scope, but still enforcing a high safety level on the evaluated
  # code itself. Returns the last expression evaluated in the block.
  def safety_thread(&block)
    scope = binding.taint
    thread = Thread.new do
      $SAFE = 4
      Thread.current[:result] = yield scope
    end
    thread.join
    thread[:result]
  end

  # :nodoc:
  def newline_strip(string)
    return nil if string.nil?
    string.gsub(/(?:^\n+|\n+$)/, '')
  end
end

require 'exercise/version'
