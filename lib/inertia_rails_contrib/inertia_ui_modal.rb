# frozen_string_literal: true

require_relative "inertia_ui_modal/renderer"
require_relative "inertia_ui_modal/redirect"
require_relative "inertia_ui_modal/inertia_rails_patch"

module InertiaRailsContrib
  module InertiaUIModal
    HEADER_BASE_URL = "X-InertiaUI-Modal-Base-Url"
    HEADER_USE_ROUTER = "X-InertiaUI-Modal-Use-Router"
    HEADER_MODAL = "X-InertiaUI-Modal"
  end
end

ActionController::Renderers.add :inertia_modal do |component, options|
  InertiaRailsContrib::InertiaUIModal::Renderer.new(
    component,
    self,
    request,
    response,
    method(:render),
    **options
  ).render
end

ActiveSupport.on_load(:action_controller_base) do
  prepend ::InertiaRailsContrib::InertiaUIModal::Redirect
end
