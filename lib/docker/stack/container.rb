# frozen_string_literal: true

require 'action_view'

module Docker
  module Stack
    class Container
      include ::ActionView::Helpers::DateHelper

      def initialize(id)
        @id = id
        @container = Docker::Container.get(id)
      end

      def service
        info('Config', 'Labels', 'com.docker.compose.service')
      end

      def status
        info('State', 'Health', 'Status')
      end

      def started
        value = info('State', 'StartedAt')
        return value if value == 'unknown'
        Time.parse(value).utc
      end

      def uptime_in_words
        return started if started == 'unknown'
        time_ago_in_words(started)
      end

      def to_h
        { id: @id, service: service, status: status, started: started, running: uptime_in_words }
      end

      private

      def info(*keys)
        result = @container.info
        keys.each { |key| result = result[key] }
        result
      end
    end
  end
end
