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

  # Base URL route that itself returns a modal (for recursion guard test)
  def modal_base
    render inertia_modal: "base_modal", props: {base_modal: "prop"}, base_url: "/base"
  end

  # Modal whose base URL points to another modal route
  def nested_modal
    render inertia_modal: "nested_modal", props: {nested: "prop"}, base_url: "/modal_base"
  end
end
