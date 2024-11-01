# frozen_string_literal: true

module InertiaRailsContrib
  class Engine < ::Rails::Engine
    initializer "inertia_rails_contrib.inertia_ui_modal" do
      require_relative "inertia_ui_modal" if InertiaRailsContrib.configuration.enable_inertia_ui_modal
    end
  end
end
