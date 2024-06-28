# frozen_string_literal: true

require "rails/generators/named_base"
require "inertia_rails_contrib/generators_helper"

module InertiaRailsContrib
  module Generators
    class ControllerTemplateBase < Rails::Generators::NamedBase
      include GeneratorsHelper
      class_option :frontend_framework, required: true, desc: "Frontend framework to generate the views for.",
        default: GeneratorsHelper.guess_the_default_framework

      argument :actions, type: :array, default: [], banner: "action action"

      def empty_views_dir
        empty_directory base_path
      end

      def copy_view_files
        actions.each do |action|
          @action = action
          @path = File.join(base_path, "#{action.camelize}.#{extension}")
          template "#{options.frontend_framework}/#{template_filename}.#{extension}", @path
        end
      end

      private

      def base_path
        File.join(pages_path, inertia_base_path)
      end

      def template_filename
        "view"
      end

      def pages_path
        "#{root_path}/pages"
      end

      def root_path
        (defined?(ViteRuby) ? ViteRuby.config.source_code_dir : "app/frontend")
      end

      def extension
        case options.frontend_framework
        when "react" then "jsx"
        when "vue" then "vue"
        when "svelte" then "svelte"
        else
          raise ArgumentError, "Unknown frontend framework: #{options.frontend_framework}"
        end
      end
    end
  end
end
