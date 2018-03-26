# frozen_string_literal: true

require 'docker/stack/container'
require 'docker/stack/controller'
require 'docker/stack/version'

module Docker
  module Stack
    class << self
      def port_for(service, environment = env)
        port_map[service.to_s][environment.to_s]
      end

      def port_map
        return @port_map unless @port_map.nil?
        config_file = [
          root.join('config', 'stack.yml'),
          File.expand_path('../../config/stack.yml', __dir__)
        ].find { |f| File.exist?(f.to_s) }
        @port_map = YAML.safe_load(File.read(config_file))
      end

      def env
        @env ||= begin
          ((rails? && Rails.env))
        rescue NoMethodError
          ActiveSupport::StringInquirer.new(
            ENV['RAILS_ENV'].presence || ENV['RACK_ENV'].presence || 'development'
          )
        end
      end

      def root
        @root ||= begin
          ((rails? && Rails.root) || Pathname.pwd)
        rescue NoMethodError
          Pathname.pwd
        end
      end

      private

      def rails?
        defined?(Rails)
      end
    end
  end
end
