# frozen_string_literal: true

require 'generators/docker/stack/service'

module Docker
  module Stack
    module Service
      class RedisGenerator < Rails::Generators::Base
        include Docker::Stack::Service

        desc %(This generator makes the following changes to your application:
       1. Adds a redis service configuration to the docker-compose.yml files.
       2. Creates a config/redis.yml file pointing to the new service.
  )

        def install_service
          template 'config/redis.yml.erb', 'config/redis.yml'
        end
      end
    end
  end
end
