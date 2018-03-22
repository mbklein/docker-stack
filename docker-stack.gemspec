# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docker/stack/version'

Gem::Specification.new do |spec|
  spec.name          = 'docker-stack'
  spec.version       = Docker::Stack::VERSION
  spec.authors       = ['Michael Klein']
  spec.email         = ['mbklein@gmail.com']

  spec.summary       = 'Support code and rake tasks for running Rails on top of Dockerized services.'
  spec.description   = 'Support code and rake tasks for running Rails on top of Dockerized services.'
  spec.homepage      = 'https://github.com/mbklein/docker-stack'
  spec.license       = 'Apache2'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'docker-api'
  spec.add_dependency 'docker-compose'
  spec.add_dependency 'rails', '~> 5.0'

  spec.add_development_dependency 'bixby'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'engine_cart'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
