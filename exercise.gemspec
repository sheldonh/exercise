# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exercise/version"

Gem::Specification.new do |s|
  s.name        = "exercise"
  s.version     = Exercise::VERSION
  s.authors     = ["Sheldon Hearn"]
  s.email       = ["sheldonh@starjuice.net"]
  s.homepage    = ""
  s.summary     = %q{Model solvable Ruby programming exercises}
  s.description = %q{Safely executes programming exercises toward a specified goal, in a specified context}

  s.rubyforge_project = "exercise"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
