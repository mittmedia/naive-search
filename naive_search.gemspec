$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "naive_search/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "naive_search"
  s.version     = NaiveSearch::VERSION
  s.authors     = ["Tomas Jogin"]
  s.email       = ["tomas@jogin.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of NaiveSearch."
  s.description = "TODO: Description of NaiveSearch."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.1"

  s.add_development_dependency "sqlite3"
end
