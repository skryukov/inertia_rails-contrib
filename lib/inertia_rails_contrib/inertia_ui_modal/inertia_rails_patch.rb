# frozen_string_literal: true

require "inertia_rails/renderer"

module InertiaRailsContrib
  module InertiaUIModal
    module RendererPatch
      def page
        super.tap do |modal|
          if @request.env[:_inertiaui_modal]
            modal[:props][:_inertiaui_modal] = @request.env[:_inertiaui_modal]
            modal[:url] = modal[:props][:_inertiaui_modal][:url]
          end
        end
      end
    end
  end
end

InertiaRails::Renderer.prepend(InertiaRailsContrib::InertiaUIModal::RendererPatch)
