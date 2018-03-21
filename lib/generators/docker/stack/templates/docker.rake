require 'docker/stack/rake_task'

namespace :docker do
  namespace(:dev)  { Docker::Stack::RakeTask.load_tasks }
  namespace(:test) { Docker::Stack::RakeTask.load_tasks(force_env: 'test', cleanup: true) }

  desc 'Spin up test stack and run specs'
  task :spec do
    Rails.env = 'test'
    DockerController.new(cleanup: true).with_containers do
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['spec'].invoke
    end
  end
end
