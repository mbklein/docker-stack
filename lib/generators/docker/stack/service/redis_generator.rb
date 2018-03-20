require 'generators/docker/stack/service_generator'

module Docker
  module Stack
    module Service
      class RedisGenerator < Docker::Stack::ServiceGenerator
        source_root File.expand_path('../templates', __dir__)

        def install_service
          copy_file 'config/redis.yml', 'config/redis.yml'
        end
      end
    end
  end
end
