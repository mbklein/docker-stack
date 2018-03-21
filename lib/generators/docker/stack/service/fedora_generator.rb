require 'generators/docker/stack/service'

module Docker
  module Stack
    module Service
      class FedoraGenerator < Rails::Generators::Base
        include Docker::Stack::Service

        desc %(This generator makes the following changes to your application:
       1. Adds a fedora service configuration to the docker-compose.yml files.
       2. Creates a config/fedora.yml file pointing to the new service.
  )

        def install_service
          copy_file 'config/fedora.yml', 'config/fedora.yml'
        end
      end
    end
  end
end
