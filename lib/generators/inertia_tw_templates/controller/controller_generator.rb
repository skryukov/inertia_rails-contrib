# frozen_string_literal: true

require "inertia_rails_contrib/generators/controller_template_base"

module InertiaTwTemplates
  module Generators
    class ControllerGenerator < InertiaRailsContrib::Generators::ControllerTemplateBase
      hide!
      source_root File.expand_path("./templates", __dir__)
    end
  end
end
