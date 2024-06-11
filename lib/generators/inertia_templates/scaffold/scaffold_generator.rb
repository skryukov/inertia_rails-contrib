# frozen_string_literal: true

require "inertia_rails_contrib/generators/scaffold_template_base"

module InertiaTemplates
  module Generators
    class ScaffoldGenerator < InertiaRailsContrib::Generators::ScaffoldTemplateBase
      hide!
      source_root File.expand_path("./templates", __dir__)
    end
  end
end
