# frozen_string_literal: true

module InertiaRailsContrib
  module InertiaUIModal
    class Renderer
      KNOWN_KEYWORDS = %i[props view_data deep_merge encrypt_history clear_history].freeze

      def initialize(component, controller, request, response, render_method, base_url: nil, **options)
        @request = request
        @response = response
        @base_url = base_url
        @inertia_renderer = InertiaRails::Renderer.new(component, controller, request, response, render_method, **options.slice(*KNOWN_KEYWORDS))
      end

      META_KEYS = %i[mergeProps deferredProps].freeze

      def render
        # If the base URL route returns a modal, render it as a plain Inertia
        # response to prevent infinite recursion (upstream #115)
        if @request.env[:_inertiaui_modal_base_dispatch] || modal_request? || base_url.blank?
          return @inertia_renderer.render
        end

        page = @inertia_renderer.page
        page[:id] = modal_id if modal_id.present?
        page[:baseUrl] = base_url
        page[:meta] = extract_meta(page)

        @request.env[:_inertiaui_modal] = page

        render_base_url
      end

      def base_url
        @request.headers[HEADER_BASE_URL] || @base_url
      end

      def modal_request?
        modal_id.present?
      end

      def modal_id
        @modal_id ||= @request.headers[HEADER_MODAL]
      end

      private

      def extract_meta(page)
        meta = {}
        META_KEYS.each do |key|
          meta[key] = page.delete(key) if page.key?(key)
        end
        meta
      end

      def render_base_url
        original_env = Rack::MockRequest.env_for(base_url)
        @request.each_header do |k, v|
          original_env[k] ||= v
        end

        request_to_base = ActionDispatch::Request.new(original_env)
        request_to_base.env[:_inertiaui_modal_base_dispatch] = true

        path = ActionDispatch::Journey::Router::Utils.normalize_path(request_to_base.path_info)
        Rails.application.routes.recognize_path_with_request(request_to_base, path, {})
        controller = request_to_base.controller_class.new
        controller.request = request_to_base
        controller.response = @response
        controller.process(request_to_base.path_parameters[:action])
        controller.response.body
      end
    end
  end
end
