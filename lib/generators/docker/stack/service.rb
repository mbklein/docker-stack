require 'generators/docker/stack/util'
require 'active_support/core_ext/hash/deep_merge'
require 'ostruct'

module Docker
  module Stack
    module Service
      def self.included(base)
        base.include Util

        base.class_option :env, type: :string, default: 'development,test'

        base.define_method :add_service do
          options[:env].split(/,/).each do |env|
            @env = env
            add_service_for_environment
          end
        end

        base.no_tasks do
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
  end
end
