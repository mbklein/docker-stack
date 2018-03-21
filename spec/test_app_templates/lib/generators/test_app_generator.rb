require 'rails/generators'

class TestAppGenerator < Rails::Generators::Base
  source_root './spec/test_app_templates'

  def install_engine
    generate 'docker:stack:install', '--services fedora,solr'
  end
end
