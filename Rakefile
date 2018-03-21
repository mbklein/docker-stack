require 'bundler/gem_tasks'
require 'engine_cart/rake_task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: :ci

task ci: ['rubocop', 'engine_cart:clean', 'engine_cart:generate', 'spec'] do
end
