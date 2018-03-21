require 'rails/generators'
require 'active_support/core_ext/hash/deep_merge'
require 'ostruct'

module Docker
  module Stack
    class ServiceGenerator < Rails::Generators::Base
      COMPOSE_FILE_VERSION = '3.4'.freeze

      class_option :env, type: :string, default: 'development,test'

      source_root File.expand_path('templates', __dir__)
      desc %(This generator makes the following changes to your application:
     1. Adds a named service to the development and test docker-compose.yml files.
)

      def add_service
        @project = Controller.default_project_name
        options[:env].split(/,/).each do |env|
          @env = env
          add_service_for_environment
        end
      end

      private

      def service
        self.class.generator_name
      end

      def add_service_for_environment
        new_service_config = current_service_config.deep_merge(service_from_template(service))
        say_status :update, "#{relative_to_original_destination_root(compose_file_full_path)} [#{service}]", true
        File.open(compose_file_full_path, 'w') do |f|
          YAML.dump(new_service_config, f)
        end
      end

      def compose_file_path
        "docker/#{@project}-#{@env}/docker-compose.yml"
      end

      def compose_file_full_path
        File.join(destination_root, compose_file_path)
      end

      def current_service_config
        create_file compose_file_path, empty_service_config unless File.exist?(compose_file_full_path)
        YAML.safe_load(File.read(compose_file_full_path))
      end

      def empty_service_config
        { 'version' => COMPOSE_FILE_VERSION, 'volumes' => {}, 'services' => {} }.to_yaml
      end

      def service_from_template(service)
        source  = File.expand_path(find_in_source_paths("services/#{service}.yml.erb"))
        context = OpenStruct.new(env: @env, port_offset: port_offset).instance_eval { binding }
        yaml = Thor::Actions::CapturableERB.new(::File.binread(source), nil, '-', '@output_buffer').tap do |erb|
          erb.filename = source
        end.result(context)
        YAML.safe_load(yaml)
      end

      def port_offset
        { 'development' => 0, 'test' => 2 }[@env] || 0
      end
    end
  end
end
