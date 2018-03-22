# frozen_string_literal: true

require 'generators/docker/stack/service'

module Docker
  module Stack
    module Service
      class LocalstackGenerator < Rails::Generators::Base
        include Docker::Stack::Service

        desc %(This generator makes the following changes to your application:
       1. Adds a localstack service configuration to the docker-compose.yml files.
       2. Creates a config/initializers/localstack_stub.rb file pointing to the new service.
  )

        def install_service
          copy_file 'config/initializers/localstack_stub.rb', 'config/initializers/localstack_stub.rb'
          gem 'aws-sdk', '~> 3.0'
        end
      end
    end
  end
end
