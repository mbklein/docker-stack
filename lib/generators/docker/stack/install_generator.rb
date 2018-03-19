require 'rails/generators'

module Docker
  module Stack
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc %(This generator makes the following changes to your application:
     1. Creates skeleton docker-compose.yml files for development and test mode
        with postgres, fedora, and solr containers.
     2. Creates lib/tasks/docker.rake.
)

      def create_stack
        project_name = Controller.default_project_name
        %w[development test].each do |env|
          copy_file "docker-compose-#{env}.yml", "docker/#{project_name}-#{env}/docker-compose.yml"
        end
        directory 'solr'
        directory 'config'
        copy_file 'docker.rake', 'lib/tasks/docker.rake'
      end
    end
  end
end
