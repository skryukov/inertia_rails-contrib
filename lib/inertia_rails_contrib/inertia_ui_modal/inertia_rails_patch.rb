# frozen_string_literal: true

require "inertia_rails/renderer"

module InertiaRailsContrib
  module InertiaUIModal
    module RendererPatch
      def page
        super.tap do |modal|
          modal_id = @request.headers[InertiaRailsContrib::InertiaUIModal::HEADER_MODAL]
          if modal_id.present? && @request.env[:_inertiaui_modal].blank?
            modal[:id] = modal_id
          end

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
