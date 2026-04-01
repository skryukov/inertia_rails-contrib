# frozen_string_literal: true

InertiaRails.configure do |config|
  config.version = "1"
  config.always_include_errors_hash = false
end

InertiaRailsContrib.configure do |config|
  config.enable_inertia_ui_modal = true
end
