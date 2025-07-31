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

      def render
        if @request.headers[HEADER_USE_ROUTER] == "0" || base_url.blank?
          return @inertia_renderer.render
        end

        page = @inertia_renderer.page
        page[:baseUrl] = base_url
        page[:meta] = {
          deferredProps: page.delete(:deferredProps),
          mergeProps: page.delete(:mergeProps)
        }

        @request.env[:_inertiaui_modal] = page

        render_base_url
      end

      def base_url
        @request.headers[HEADER_BASE_URL] || @base_url
      end

      def render_base_url
        original_env = Rack::MockRequest.env_for(base_url)
        @request.each_header do |k, v|
          original_env[k] ||= v
        end

        request_to_base = ActionDispatch::Request.new(original_env)

        path = ActionDispatch::Journey::Router::Utils.normalize_path(request_to_base.path_info)
        Rails.application.routes.recognize_path_with_request(request_to_base, path, {})
        controller = request_to_base.controller_class.new
        controller.request = request_to_base
        controller.response = @response
        controller.process(request_to_base.path_parameters[:action])
      end
    end
  end
end
