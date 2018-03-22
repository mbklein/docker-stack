# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Docker::Stack do
  it 'has a version number' do
    expect(Docker::Stack::VERSION).not_to be nil
  end

  context 'compose files' do
    let(:dev_config_file) do
      File.expand_path('.docker-stack/internal-development/docker-compose.yml', EngineCart.destination)
    end
    let(:test_config_file) do
      File.expand_path('.docker-stack/internal-test/docker-compose.yml', EngineCart.destination)
    end
    let(:development_config) { YAML.safe_load(File.read(dev_config_file)) }
    let(:test_config) { YAML.safe_load(File.read(test_config_file)) }

    it 'should define services' do
      expect(development_config['services']).to have_key('fedora')
      expect(development_config['services']).to have_key('solr')
      expect(development_config['services']).not_to have_key('foo')

      expect(test_config['services']).to have_key('fedora')
      expect(test_config['services']).to have_key('solr')
      expect(test_config['services']).not_to have_key('foo')
    end

    it 'should use the correct ports' do
      expect(development_config['services']['fedora']['ports']).to include('8984:8080')
      expect(development_config['services']['solr']['ports']).to include('8983:8983')

      expect(test_config['services']['fedora']['ports']).to include('8986:8080')
      expect(test_config['services']['solr']['ports']).to include('8985:8983')
    end
  end

  context 'generators' do
    before(:all) do
      @generators = EngineCart.within_test_app { `rails generate | grep docker:stack`.lines.map(&:strip) }
    end

    it 'docker:stack:install' do
      expect(@generators).to include('docker:stack:install')
    end

    %w[fedora localstack postgres redis solr].each do |generator_name|
      it "docker:stack:service:#{generator_name}" do
        expect(@generators).to include("docker:stack:service:#{generator_name}")
      end
    end
  end

  context 'rake tasks' do
    before(:all) do
      @tasks = EngineCart.within_test_app { `bundle exec rake -T docker` }
    end

    it 'docker:spec' do
      expect(@tasks).to include('rake docker:spec')
    end

    %w[dev test].each do |env|
      context env do
        %w[clean daemon down logs reset status up].each do |action|
          it "docker:#{env}:#{action}" do
            expect(@tasks).to include("rake docker:#{env}:#{action}")
          end
        end
      end
    end
  end
end
