# frozen_string_literal: true

module InertiaRailsContrib
  module InertiaUIModal
    module Redirect
      def redirect_back_or_to(fallback_location, allow_other_host: _allow_other_host, **options)
        inertia_modal_referer = request.headers[HEADER_BASE_URL]
        if inertia_modal_referer && (allow_other_host || _url_host_allowed?(inertia_modal_referer))
          redirect_to inertia_modal_referer, allow_other_host: allow_other_host, **options
        else
          super
        end
      end
    end
  end
end
