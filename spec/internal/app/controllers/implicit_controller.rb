# frozen_string_literal: true

class ImplicitController < ActionController::Base
  layout "application"

  # Simulates controllers that use implicit rendering (e.g. alba-inertia).
  # The action sets instance variables and returns a non-string value;
  # rendering is handled by default_render.
  def base
    @items = [1, 2, 3]
  end

  def modal
    render inertia_modal: "modal", props: {
      hello: "modal"
    }, base_url: "/implicit_base"
  end

  private

  def default_render(*)
    render inertia: "base", props: {base: "implicit"}
  end
end
