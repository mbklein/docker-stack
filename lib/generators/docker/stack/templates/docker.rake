require 'docker/stack/rake_task'

namespace :docker do
  namespace(:dev)  { Docker::Stack::RakeTask.load_tasks }
  namespace(:test) { Docker::Stack::RakeTask.load_tasks(force_env: 'test', cleanup: true) }
  task(:dev)       { Rake::Task['docker:dev:up'].invoke }
  task(:test)      { Rake::Task['docker:test:up'].invoke }
end
