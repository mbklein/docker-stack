require 'spec_helper'

RSpec.describe Docker::Stack do
  it 'has a version number' do
    expect(Docker::Stack::VERSION).not_to be nil
  end

  context 'generators' do
    before(:all) do
      @generators = EngineCart.within_test_app { `rails generate | grep docker:stack`.lines.map(&:strip) }
    end

    %w[install service].each do |generator_name|
      it "docker:stack:#{generator_name}" do
        expect(@generators).to include("docker:stack:#{generator_name}")
      end
    end

    %w[fedora postgres redis solr].each do |generator_name|
      it "docker:stack:service:#{generator_name}" do
        expect(@generators).to include("docker:stack:service:#{generator_name}")
      end
    end
  end

  context 'rake tasks' do
    before(:all) do
      @output = EngineCart.within_test_app { `bundle exec rake -T docker` }
    end

    it 'docker:spec' do
      expect(@output).to include('rake docker:spec')
    end

    %w[dev test].each do |env|
      context env do
        %w[clean daemon down logs reset status up].each do |action|
          it "docker:#{env}:#{action}" do
            expect(@output).to include("rake docker:#{env}:#{action}")
          end
        end
      end
    end
  end
end
