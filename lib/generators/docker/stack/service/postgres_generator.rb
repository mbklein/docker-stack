require 'generators/docker/stack/service_generator'

module Docker
  module Stack
    module Service
      class PostgresGenerator < Docker::Stack::ServiceGenerator
        source_root File.expand_path('../templates', __dir__)

        def install_service
          copy_file 'config/database.yml', 'config/database.yml'
          append_to_file 'Gemfile', "gem 'pg'"
        end
      end
    end
  end
end
