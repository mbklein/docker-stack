# frozen_string_literal: true

require 'docker/stack'
require 'aws-sdk-core'

module Docker
  module Stack
    module Localstack
      module EndpointStub
        class Plugin < Seahorse::Client::Plugin
          PORT_MAP = {
            'Aws::APIGateway'           => 4567,
            'Aws::CloudFormation'       => 4581,
            'Aws::CloudWatch'           => 4582,
            'Aws::DynamoDB'             => 4569,
            'Aws::DynamoDBStreams'      => 4570,
            'Aws::Elasticsearch'        => 4571,
            'Aws::ElasticsearchService' => 4578,
            'Aws::Firehose'             => 4573,
            'Aws::Kinesis'              => 4568,
            'Aws::Lambda'               => 4574,
            'Aws::Redshift'             => 4577,
            'Aws::Route53'              => 4580,
            'Aws::S3'                   => 4572,
            'Aws::SES'                  => 4579,
            'Aws::SNS'                  => 4575,
            'Aws::SQS'                  => 4576,
            'Aws::SSM'                  => 4583
          }.freeze

          def after_initialize(client)
            client.config.endpoint = endpoint_for(client) || client.config.endpoint
          end

          private

          def endpoint_for(client)
            base_port = PORT_MAP[client.class.parent_name]
            return nil if base_port.nil?
            base_url = ENV['LOCALSTACK_ENDPOINT'] || 'http://localhost'
            offset = ENV['LOCALSTACK_OFFSET']&.to_i || Docker::Stack.port_for(:localstack)
            base_uri = URI.parse(base_url)
            base_uri.port = base_port + offset
            base_uri.to_s
          end
        end

        def self.stub_endpoints!
          Aws.config.update(
            region: 'us-east-1',
            credentials: Aws::Credentials.new('localstack-key', 'localstack-secret')
          )
          classes_to_stub = [Seahorse::Client::Base] + Seahorse::Client::Base.descendants
          classes_to_stub.each do |klass|
            klass.add_plugin(Plugin) unless klass.plugins.include?(Plugin)
          end

          return unless defined?(Aws::S3)
          Aws::S3::Plugins::BucketDns.options.find { |opt| opt.name == :force_path_style }.default = true
        end
      end
    end
  end
end
