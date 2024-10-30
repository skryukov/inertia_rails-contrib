# frozen_string_literal: true

module InertiaRailsContrib
  module InertiaUIModal
    class Renderer
      def initialize(component, controller, request, response, render_method, base_url: nil, **options)
        @request = request
        @response = response
        @base_url = base_url
        @inertia_renderer = InertiaRails::Renderer.new(component, controller, request, response, render_method, **options)
      end

      def render
        if @request.headers[HEADER_USE_ROUTER] == "0" || base_url.blank?
          return @inertia_renderer.render
        end

        @request.env[:_inertiaui_modal] = @inertia_renderer.page.merge(baseUrl: base_url)

        render_base_url
      end

      def base_url
        @request.headers[HEADER_BASE_URL] || @base_url
      end

      def render_base_url
        original_env = Rack::MockRequest.env_for(
          base_url,
          method: @request.method,
          params: @request.params
        )
        @request.each_header do |k, v|
          original_env[k] ||= v
        end

        original_request = ActionDispatch::Request.new(original_env)

        path = ActionDispatch::Journey::Router::Utils.normalize_path(original_request.path_info)
        Rails.application.routes.recognize_path_with_request(original_request, path, {})
        controller = original_request.controller_class.new
        controller.request = @request
        controller.response = @response
        controller.process(original_request.path_parameters[:action])
      end
    end
  end
end
