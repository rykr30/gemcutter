dbconf = ActiveRecord::Base.connection_handler.connection_pools[ActiveRecord::Base.name].spec.config
require 'rack-sparklines/cachers/memory'
Rails.configuration.middleware.insert_before Rack::Lock, Rack::Sparklines,
  :prefix  => "/sparks",
  :handler => Sparkline::WebCsvHandler.new(dbconf[:sparklines] || "http://localhost:3000/stats"),
  :cacher  => Rack::Sparklines::Cachers::Memory.new(5.minutes),
  :spark   => {:step => 6, :height => 16}