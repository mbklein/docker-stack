require 'rails/generators'
require 'active_support/core_ext/hash/keys'

module Docker
  module Stack
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc %(This generator makes the following changes to your application:
     1. Creates skeleton docker-compose.yml files for development and test mode
        with fedora, and solr containers.
     2. Creates lib/tasks/docker.rake.
)

      def create_stack
        generate 'docker:stack:service:fedora'
        generate 'docker:stack:service:solr'
        copy_file 'docker.rake', 'lib/tasks/docker.rake'
      end
    end
  end
end
