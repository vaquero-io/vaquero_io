require 'bundler'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'yard'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec)
Cucumber::Rake::Task.new(:features)

task :style do
  sh 'rubocop'
end

task :doc do
  sh 'yard'
end

task default: [:spec, :features, :style, :doc]
