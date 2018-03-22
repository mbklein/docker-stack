# frozen_string_literal: true

module Docker
  module Stack
    module Util
      COMPOSE_FILE_VERSION = '3.4'

      def self.included(base)
        base.source_root File.expand_path('templates', __dir__)

        base.no_tasks do
          def compose_file_path(env = @env)
            ".docker-stack/#{project}-#{env}/docker-compose.yml"
          end

          def compose_file_full_path
            File.join(destination_root, compose_file_path)
          end

          def current_service_config
            create_file compose_file_path, empty_service_config.to_yaml unless File.exist?(compose_file_full_path)
            YAML.safe_load(File.read(compose_file_full_path))
          end

          def empty_service_config
            {
              'version'  => COMPOSE_FILE_VERSION,
              'volumes'  => {},
              'services' => {}
            }
          end

          def project
            @project ||= Controller.default_project_name
          end
        end
      end
    end
  end
end
