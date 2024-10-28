# lib/inertia_rails_contrib/engine.rb
module InertiaRailsContrib
  class Configuration
    attr_accessor :enable_inertia_ui_modal

    def initialize
      @enable_inertia_ui_modal = false
    end
  end
end
