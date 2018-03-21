require 'generators/docker/stack/util'
require 'active_support/core_ext/hash/keys'

module Docker
  module Stack
    class InstallGenerator < Rails::Generators::Base
      include Util

      class_option :env, type: :string, default: nil
      class_option :services, type: :string, default: ''

      source_root File.expand_path('templates', __dir__)
      desc %(This generator makes the following changes to your application:
     1. Creates skeleton docker-compose.yml files for development and test mode
        with fedora, and solr containers.
     2. Creates lib/tasks/docker.rake.
)

      def create_service_configs
        environments.each do |env|
          create_file compose_file_path(env), empty_service_config.to_yaml, force: false, skip: true
        end
      end

      def create_services
        env_param = "--env #{options[:env]}" unless options[:env].nil?
        services.each do |service|
          generate "docker:stack:service:#{service}", env_param
        end
      end

      def add_rake_tasks
        copy_file 'docker.rake', 'lib/tasks/docker.rake'
      end

      no_tasks do
        def environments
          return %w[development test] if options[:env].nil?
          options[:env].split(/,/)
        end

        def services
          options[:services].split(/,/)
        end
      end
    end
  end
end
