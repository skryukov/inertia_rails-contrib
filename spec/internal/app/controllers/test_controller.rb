# frozen_string_literal: true

class TestController < ActionController::Base
  layout "application"

  def base
    render inertia: "base", props: {base: "prop"}
  end

  def modal
    render inertia_modal: "modal", props: {
      hello: "modal",
      optional_param: InertiaRails.optional { "optional" },
      deferred_param: InertiaRails.defer { "deferred" },
      merge_param: InertiaRails.defer(group: "custom", merge: true) { {additional: "data"} }
    }, base_url: "/base"
  end
end
