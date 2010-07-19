# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'solr_pagination'

Rails::Initializer.run do |config|

  %w(middleware).each do |dir|
    config.load_paths << "#{RAILS_ROOT}/app/#{dir}" 
  end
  
  config.gem 'mime-types', :lib => 'mime/types'
  config.gem 'paperclip'
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'websolr-acts_as_solr'
  config.gem 'clearance'
  
  config.after_initialize do
    config.gem "right_aws"
  end

  config.time_zone = 'UTC'

end