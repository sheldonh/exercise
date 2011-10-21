require 'spec_helper'

describe Exercise do

  describe "#initialize" do
    it "takes context code and goal code as strings if given" do
      exercise = Exercise.new "a = [:contents]", "a.empty?"
      exercise.context.should == "a = [:contents]"
      exercise.goal.should == "a.empty?"
    end

    it "yields self to a block, if given, that can set context and goal" do
      exercise = Exercise.new do |e|
        e.context %{
          a = rand(100)
          b = rand(100)
        }
        e.goal %{
          "c == a + b"
        }
      end
      exercise.context.should match /a = rand/
      exercise.goal.should match /c == /
    end
  end

  describe "#context" do
    it "returns the context code if called with no arguments" do
      exercise = Exercise.new "a = Rational.new(1, 3)", "b == 1"
      exercise.context.should == "a = Rational.new(1, 3)"
    end

    it "returns the context code with leading and trailing newlines removed" do
      exercise = Exercise.new "\n\na = 1\n\n", "a == 2"
      exercise.context.should == "a = 1"
    end

    it "sets and returns the context code if passed a string argument" do
      exercise = Exercise.new
      exercise.context("e = :awesome").should == "e = :awesome"
      exercise.context.should == "e = :awesome"
    end
  end

  describe "#goal" do
    it "returns the goal code if called with no arguments" do
      exercise = Exercise.new "a = rand(3)", "b == Rational(1/3)"
      exercise.goal.should == "b == Rational(1/3)"
    end

    it "returns the goal code with leading and trailing newlines removed" do
      exercise = Exercise.new "a = 1", "\n\na == 2\n\n"
      exercise.goal.should == "a == 2"
    end

    it "sets and returns the goal code if passed a string argument" do
      exercise = Exercise.new
      exercise.goal("e.is_a?(Awesome)").should == "e.is_a?(Awesome)"
      exercise.goal.should == "e.is_a?(Awesome)"
    end
  end

  describe "#solve(solution)" do
    it "takes solution code as a string and returns true if the code solves the problem" do
      exercise = Exercise.new "a = 1", "a == 2"
      exercise.solve("a += 1").should be_true
    end

    it "takes solution code as a string and returns false if the code does not solve the problem" do
      exercise = Exercise.new "s = 'forward'", "s == 'drawrof'"
      exercise.solve("s.downcase").should be_false
    end

    it "takes solution code as a string and returns false if any code raises an exception" do
      exercise = Exercise.new 'a = rand', 'b == a * 100'
      expect { exercise.solve("a *= '100'") }.to_not raise_error
    end

    it "takes solution code as a string and returns false if any code violates Ruby's highest safe level" do
      exercise = Exercise.new 'string = "a" << rand(10).to_s', 'symbol == string.intern'
      exercise.solve('@goal = "true"').should be_false
    end
  end
end
