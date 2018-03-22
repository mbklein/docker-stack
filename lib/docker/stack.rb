# frozen_string_literal: true

require 'docker/stack/container'
require 'docker/stack/controller'
require 'docker/stack/version'

module Docker
  module Stack
    def self.port_for(service, environment = Rails.env)
      port_map[service.to_s][environment.to_s]
    end

    def self.port_map
      return @port_map unless @port_map.nil?
      config_file = [
        Rails.root&.join('config', 'stack.yml'),
        File.expand_path('../../config/stack.yml', __dir__)
      ].find { |f| File.exist?(f.to_s) }
      @port_map = YAML.safe_load(File.read(config_file))
    end
  end
end
