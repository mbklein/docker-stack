# frozen_string_literal: true

require 'generators/docker/stack/service'

module Docker
  module Stack
    module Service
      class SolrGenerator < Rails::Generators::Base
        include Docker::Stack::Service

        desc %(This generator makes the following changes to your application:
       1. Adds a solr service configuration to the docker-compose.yml files.
       2. Creates a config/solr.yml file pointing to the new service.
       3. Adds a solr directory to the root containing solr config files for the solr service.
  )

        def install_service
          copy_file 'config/solr.yml', 'config/solr.yml'
          directory 'solr'
        end
      end
    end
  end
end
