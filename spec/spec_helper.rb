# frozen_string_literal: true

require 'simplecov'
require 'coveralls'

SimpleCov.root(File.expand_path('..', __dir__))
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start('rails') do
  add_filter '/.internal_test_app'
  add_filter '/lib/generators'
  add_filter '/spec'
  add_filter '/tasks'
  add_filter '/lib/docker/stack/version.rb'
end
SimpleCov.command_name 'spec'

require 'docker/stack'
require 'rails'
require 'engine_cart'
require 'rspec'
require 'fileutils'

RSpec.configure do |config|
end
