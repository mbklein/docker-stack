# frozen_string_literal: true

require 'docker/stack'

# rubocop:disable all
module Docker
  module Stack
    module RakeTask
      class << self
        include ::Rake::DSL if defined?(::Rake::DSL)

        def load_tasks(force_env: nil, cleanup: false)
          desc 'Clean up the development stack'
          task :clean do
            Controller.new(env: force_env, cleanup: true).down
          end

          desc 'Run the stack in the background'
          task :daemon do
            Controller.new(env: force_env, daemon: true).start
          end

          desc 'Bring down the stack'
          task :down do
            Controller.new(env: force_env, cleanup: cleanup).down
          end

          desc 'Show the server logs'
          task :logs do
            services = ENV['SERVICES'].to_s.split(/[\s,;]+/)
            Controller.new(env: force_env).logs(*services)
          end

          desc 'Remove containers, volumes, and images'
          task :reset do
            Controller.new(env: force_env).reset! do |result|
              results = JSON.parse(result)
              results.each do |result_hash|
                result_hash.each_pair do |action, target|
                  puts "#{action} #{target}"
                end
              end
            end
          end

          desc 'Show server status'
          task :status do
            status = Controller.new(env: force_env).status
            puts '%-20s %-16s %-20s' % ['SERVICE', 'STATUS', 'UPTIME']
            puts '-' * 56
            status.each do |s|
              puts '%-20s %-16s %-20s' % s.values_at(:service, :status, :running)
            end
          end

          desc 'Run the stack in the foreground'
          task :up do
            Controller.new(env: force_env, cleanup: cleanup).start
          end
        end
      end
    end
  end
end
# rubocop:enable all
