require 'rails/generators'
require 'active_support/core_ext/hash/deep_merge'
require 'ostruct'

module Docker
  module Stack
    class ServiceGenerator < Rails::Generators::Base
      class_option :env, type: :string, default: 'development,test'

      source_root File.expand_path('templates', __dir__)
      desc %(This generator makes the following changes to your application:
     1. Adds a named service to the development and test docker-compose.yml files.
)

      def add_service
        @project = Controller.default_project_name
        service = self.class.generator_name
        options[:env].split(/,/).each do |env|
          compose_file = File.join(destination_root, compose_file_path(env))
          unless File.exists?(compose_file)
            copy_file 'docker-compose-skeleton.yml', compose_file_path(env)
          end
          compose_spec = YAML.safe_load(File.read(compose_file))
          service_spec = service_from_template(service, env)
          compose_spec.deep_merge!(service_spec)
          say_status :update, "#{relative_to_original_destination_root(compose_file)} [#{service}]", true
          File.open(compose_file, 'w') { |f| YAML.dump(compose_spec, f) }
        end
      end

      private

      def compose_file_path(env)
        "docker/#{@project}-#{env}/docker-compose.yml"
      end

      def service_from_template(service, env)
        source  = File.expand_path(find_in_source_paths("services/#{service}.yml.erb"))
        context = OpenStruct.new(env: env, env_offset: port_offset_for(env)).instance_eval { binding }
        yaml = Thor::Actions::CapturableERB.new(::File.binread(source), nil, "-", "@output_buffer").tap do |erb|
          erb.filename = source
        end.result(context)
        YAML.safe_load(yaml)
      end

      def port_offset_for(env)
        { 'development' => 0, 'test' => 2 }[env] || 0
      end
    end
  end
end
