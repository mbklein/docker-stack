require 'generators/docker/stack/service_generator'

module Docker
  module Stack
    module Service
      class SolrGenerator < Docker::Stack::ServiceGenerator
        source_root File.expand_path('../templates', __dir__)

        def install_service
          copy_file 'config/solr.yml', 'config/solr.yml'
          directory 'solr'
        end
      end
    end
  end
end
