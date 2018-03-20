require 'generators/docker/stack/service_generator'

module Docker
  module Stack
    module Service
      class FedoraGenerator < Docker::Stack::ServiceGenerator
        source_root File.expand_path('../templates', __dir__)

        def install_service
          copy_file 'config/fedora.yml', 'config/fedora.yml'
        end
      end
    end
  end
end
