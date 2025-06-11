# frozen_string_literal: true

require "bundler/setup"
require "combustion"

Combustion.initialize! :action_controller do
  config.hosts.clear
  config.secret_key_base = "test_secret"
  config.cache_classes = true
  config.eager_load = false
end

require "inertia_rails-contrib"
require "rspec/rails"

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  def app
    Rails.application
  end
end
