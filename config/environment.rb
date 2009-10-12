RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'

  config.gem "thoughtbot-clearance",
    :lib     => 'clearance',
    :source  => 'http://gems.github.com',
    :version => '0.8.2'
  config.gem "ddollar-pacecar",
    :lib     => 'pacecar',
    :source  => 'http://gems.github.com',
    :version => '1.1.6'
  config.gem 'mislav-will_paginate',
    :version => '~> 2.3.11',
    :lib     => 'will_paginate',
    :source  => 'http://gems.github.com'
  config.gem 'aws-s3',
    :version => '0.6.2',
    :lib     => 'aws/s3'
  config.gem "ambethia-smtp-tls",
    :lib => "smtp-tls",
    :version => "1.1.2",
    :source  => "http://gems.github.com"
  config.gem "memcache-client",
    :lib     => "memcache",
    :version => "1.7.2"
  config.gem "rtomayko-rack-cache",
    :lib     => "rack/cache",
    :version => "0.5.1"
  config.gem "gchartrb",
    :lib     => "google_chart"
  config.gem "sinatra"
  config.gem "rack-sparklines",
    :version => "~> 1.1"

  config.after_initialize do
    dbconf = ActiveRecord::Base.connection_handler.connection_pools[ActiveRecord::Base.name].spec.config
    require 'rack-sparklines/cachers/memory'
    config.middleware.insert_before Rack::Lock, Rack::Sparklines,
      :prefix  => "/sparks",
      :handler => Sparkline::WebCsvHandler.new(dbconf[:sparklines] || "http://localhost:3000/stats"),
      :cacher  => Rack::Sparklines::Cachers::Memory.new(5.minutes),
      :spark   => {:step => 6, :height => 16}
  end

  config.action_mailer.delivery_method = :smtp
end

DO_NOT_REPLY = "donotreply@gemcutter.org"

require 'lib/indexer'
require 'lib/core_ext/string'

Gem.configuration.verbose = false
ActiveRecord::Base.include_root_in_json = false

require 'clearance/sessions_controller'

require 'rdoc/markup/simple_markup'
require 'rdoc/markup/simple_markup/to_html'
