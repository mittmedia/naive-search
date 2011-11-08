$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "naive_search/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "naive-search"
  s.version     = NaiveSearch::VERSION
  s.authors     = ["Tomas Jogin"]
  s.email       = ["tomas@jogin.com"]
  s.homepage    = "http://github.com/tjogin/naive_search"
  s.summary     = "Naive full text search ordered by relevance for ActiveRecord"
  s.description = "Provides very simple full text searching for ActiveRecord, without depending on any particular SQL-feature, search server or anything like that."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.1"

  s.add_development_dependency "sqlite3"
end
