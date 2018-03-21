# Docker::Stack

Rails generators, Rake tasks, and support modules to run dependencies in Docker containers.

Code: [![Version](https://badge.fury.io/rb/docker-stack.png)](http://badge.fury.io/rb/docker-stack)
[![Build Status](https://travis-ci.org/mbklein/docker-stack.png?branch=master)](https://travis-ci.org/mbklein/docker-stack)
[![Code Climate](https://codeclimate.com/github/mbklein/docker-stack/badges/gpa.svg)](https://codeclimate.com/github/mbklein/docker-stack)
[![Dependency Update Status](https://gemnasium.com/mbklein/docker-stack.png)](https://gemnasium.com/mbklein/docker-stack)

Docs: [![Documentation Status](https://inch-ci.org/github/mbklein/docker-stack.svg?branch=master)](https://inch-ci.org/github/mbklein/docker-stack)
[![API Docs](http://img.shields.io/badge/API-docs-blue.svg)](http://rubydoc.info/gems/docker-stack)
[![Apache 2.0 License](http://img.shields.io/badge/APACHE2-license-blue.svg)](./LICENSE.txt)

Originally written as a drop-in replacement for [`solr_wrapper`](https://github.com/cbeer/solr_wrapper) and [`fcrepo_wrapper`](https://github.com/cbeer/fcrepo_wrapper) to ease development and testing of [Samvera](https://github.com/mbklein/) applications, but with an eye toward adding support for additional services.

## Prerequisites

`Docker::Stack` depends on [Docker](https://docker.com/) for container virtualization. Before using this gem to start or manage support services, please download and install the [Docker Community Edition](https://store.docker.com/search?type=edition&offering=community).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'docker-stack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docker-stack

## Usage

### Initial Setup

From your application root, run:

    $ rails generate docker:stack:install

This creates the Docker configuration files for the development and test environments, and adds `lib/tasks/docker.rake` to provide the Docker-related rake tasks to your application.

Then run the service generator for each support service your application needs:

    $ rails generate docker:stack:service:fedora
    $ rails generate docker:stack:service:solr

This will create the Docker service definitions for Fedora and Solr and drop the appropriate configuration files to point to them in the `config` directory. The Solr generator also creates a `solr` directory containing default core configuration files.

To do all of the above with one command, you can run:

    $ rails generate docker:stack:install --services fedora,solr

### Controlling the Stack

`Docker::Stack` defines a bunch of rake tasks to control the Docker services (and sometimes do other things). These are defined in your application in `lib/tasks/docker.rake`, and can be customized according to your application's needs. The following descriptions apply to the default tasks installed by the `docker:stack:install` generator.

#### Environment-Specific Tasks

Every `docker:dev` task is also available as a `docker:test` task. The gem forwards different ports to the host in development and test modes, so both stacks can be running at once. The only difference between the two is that the test stack cleans up after itself automatically when it terminates, while the development stack keeps its data around.

##### Spin up the stack in the foreground

    $ rake docker:dev:up

The required Docker machine images will be downloaded and registered the first time you run this command. Subsequent runs will be much faster.

##### Spin up the stack in the background

    $ rake docker:dev:daemon

##### Terminate running services

Even if they're running in the foreground in another tab!

    $ rake docker:dev:down

##### Display the status of all running services

    $ rake docker:dev:status

##### Clean up all persistent data

    $ rake docker:dev:clean

##### Display container logs

    $ rake docker:dev:logs

Similar to `tail -f` on a file.
Add a `SERVICES` variable to display only specific services' logs (e.g., `rake docker:dev:logs SERVICES=fedora`)

##### Reset the entire stack

    $ rake docker:dev:reset

AKA "The Nuclear Option." Removes all containers, data, and machine images associated with this stack. This will result in Docker images being re-downloaded and initialized the next time you spin things up.

#### Convenience Tasks

##### Run application tests under the test stack

    $ rake docker:spec

1. Spins up the test environment
2. Invokes the `db:setup` task
3. Invokes the first task it finds named `spec` or `rspec` or matching the value of the `SPEC_TASK` environment variable
4. Terminates and cleans up the test environment

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mbklein/docker-stack.

## License

The gem is available as open source under the terms of the [Apache 2.0 License](https://opensource.org/licenses/Apache-2.0).
