require "rails/generators/rails/controller/controller_generator"
require "inertia_rails_contrib/generators_helper"

module Inertia
  module Generators
    class ControllerGenerator < Rails::Generators::ControllerGenerator
      include InertiaRailsContrib::GeneratorsHelper

      source_root File.expand_path("./templates", __dir__)

      remove_hook_for :template_engine

      hook_for :inertia_templates, required: true, default: InertiaRailsContrib::GeneratorsHelper.guess_inertia_template
    end
  end
end
