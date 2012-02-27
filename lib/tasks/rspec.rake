begin
  require "rake"
  require "rspec"
  require "rspec/core/rake_task"

  desc "default: run specs"
  task default: :spec

  desc "run specs"
  RSpec::Core::RakeTask.new do |t|
    t.pattern = "./spec/**/*_spec.rb"
  end
end

