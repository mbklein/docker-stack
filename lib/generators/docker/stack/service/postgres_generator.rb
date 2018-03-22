# frozen_string_literal: true

require 'generators/docker/stack/service'

module Docker
  module Stack
    module Service
      class PostgresGenerator < Rails::Generators::Base
        include Docker::Stack::Service

        desc %(This generator makes the following changes to your application:
       1. Adds a db service configuration to the docker-compose.yml files.
       2. Creates a config/database.yml file pointing to the new service.
       3. Adds the 'pg' gem to the Gemfile.
  )

        def install_service
          copy_file 'config/database.yml', 'config/database.yml'
          gem 'pg'
        end
      end
    end
  end
end
