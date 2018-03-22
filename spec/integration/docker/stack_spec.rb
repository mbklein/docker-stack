# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Docker::Stack do
  it 'has a version number' do
    expect(Docker::Stack::VERSION).not_to be nil
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
