class InertiaExampleController < ApplicationController
  def index
    render inertia: "InertiaExample", props: {
      name: params.fetch(:name, "World")
    }
  end
end
