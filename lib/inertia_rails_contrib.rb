# frozen_string_literal: true

if defined?(Rails)
  require "inertia_rails"
  require_relative "inertia_rails_contrib/engine"
end

require_relative "inertia_rails_contrib/version"
require_relative "inertia_rails_contrib/configuration"

module InertiaRailsContrib
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
