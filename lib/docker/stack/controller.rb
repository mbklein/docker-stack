require 'docker/compose'
require 'docker-api'

module Docker
  module Stack
    class Controller
      attr_reader :dc, :cleanup, :daemon

      def self.default_project_name
        Rails.application.class.parent_name.underscore
      end

      def initialize(project: self.class.default_project_name, env: nil, cleanup: false, daemon: false)
        env = Rails.env if env.nil?
        project_and_env = [project, env].join('-')
        @workdir = Rails.root.join('.docker-stack', project_and_env)
        @dc = ::Docker::Compose::Session.new(dir: @workdir)
        @cleanup = cleanup
        @daemon = daemon
      end

      def reset!
        down(cleanup: true)
        images = config['services'].values.map { |conf| conf['image'] }
        images.each do |image_name|
          begin
            image = ::Docker::Image.get(image_name)
            result = image.remove(prune: true)
            yield result if block_given?
          rescue ::Docker::Error::NotFoundError
            yield %{[{"Skipped":"#{image_name} (image not present)"}]}
          end
        end
        ::Docker::Image.prune
      end

      def status
        containers = dc.ps.map(&:id)
        containers.map do |c|
          begin
            container = Container.new(c)
            container.to_h
          rescue StandardError
            { id: c, service: 'unknown', status: 'unknown', started: 'unknown', running: 'unknown' }
          end
        end
      end

      # rubocop:disable Style/StderrPuts
      def wait_for_services
        Timeout.timeout(120) do
          $stderr.print 'Waiting up to two minutes for services to become healthy.' if warn?
          loop do
            break if status.all? { |v| v[:status] == 'healthy' }
            $stderr.print '.' if warn?
            sleep 2
          end
          $stderr.puts if warn?
        end
        true
      rescue Timeout::Error
        raise 'Timed out waiting for services to become healthy'
      end
      # rubocop:enable Style/StderrPuts

      def run
        dc.up(detached: @daemon || block_given?)
        return true unless block_given?

        begin
          wait_for_services
          yield
        ensure
          down
        end
      end

      def logs(*services)
        trap_int(terminate: false) { dc.run!('logs', '-f', services) }
      end

      def start(&block)
        trap_int { run(&block) }
      end

      def with_containers(&block)
        trap_int { run(&block) }
      end

      def down(cleanup: @cleanup)
        dc.run!('down', v: cleanup)
      end

      private

      def config
        @config ||= YAML.safe_load(File.read(File.join(dc.dir, dc.file)))
      end

      def trap_int(terminate: true)
        old_trap = Signal.trap('INT') do
          down if terminate
          raise SystemExit
        end
        yield
      ensure
        Signal.trap('INT', old_trap)
      end

      def warn?
        $-W > 0 # rubocop:disable Style/GlobalVars
      end
    end
  end
end
