module Inertia
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("./templates", __dir__)

      APPLICATION_LAYOUT = Rails.root.join("app/views/layouts/application.html.erb")

      FRAMEWORKS = {
        "react" => {
          packages: %w[@inertiajs/react react react-dom],
          dev_packages: %w[@vitejs/plugin-react],
          vite_plugin_import: "import react from '@vitejs/plugin-react'",
          vite_plugin_call: "react()",
          copy_files: {
            "InertiaExample.jsx" => "#{root_path}/pages/InertiaExample.jsx",
            "InertiaExample.module.css" => "#{root_path}/pages/InertiaExample.module.css",
            "../assets/react.svg" => "#{root_path}/assets/react.svg",
            "../assets/inertia.svg" => "#{root_path}/assets/inertia.svg",
            "../assets/vite_ruby.svg" => "#{root_path}/assets/vite_ruby.svg"
          }
        },
        "vue" => {
          packages: %w[@inertiajs/vue3 vue],
          dev_packages: %w[@vitejs/plugin-vue],
          vite_plugin_import: "import vue from '@vitejs/plugin-vue'",
          vite_plugin_call: "vue()",
          copy_files: {
            "InertiaExample.vue" => "#{root_path}/pages/InertiaExample.vue",
            "../assets/vue.svg" => "#{root_path}/assets/vue.svg",
            "../assets/inertia.svg" => "#{root_path}/assets/inertia.svg",
            "../assets/vite_ruby.svg" => "#{root_path}/assets/vite_ruby.svg"
          }
        },
        "svelte" => {
          packages: %w[@inertiajs/svelte svelte @sveltejs/vite-plugin-svelte],
          dev_packages: %w[@vitejs/plugin-vue],
          vite_plugin_import: "import { svelte } from '@sveltejs/vite-plugin-svelte'",
          vite_plugin_call: "svelte()",
          copy_files: {
            "svelte.config.js" => "svelte.config.js",
            "InertiaExample.svelte" => "#{root_path}/pages/InertiaExample.svelte",
            "../assets/svelte.svg" => "#{root_path}/assets/svelte.svg",
            "../assets/inertia.svg" => "#{root_path}/assets/inertia.svg",
            "../assets/vite_ruby.svg" => "#{root_path}/assets/vite_ruby.svg"
          }
        }
      }

      def install
        say "Installing Inertia's Rails adapter"

        if package_manager.nil?
          say "Could not find a package.json file to install Inertia to.", :red
          exit!
        end

        unless ruby_vite?
          say "Could not find a Vite configuration file `config/vite.json`. This generator only supports Ruby on Rails with Vite.", :red
          exit!
        end

        install_inertia

        say "Inertia's Rails adapter successfully installed", :green
      end

      private

      def install_inertia
        say "Adding Inertia's Rails adapter initializer"
        template "initializer.rb", Rails.root.join("config/initializers/inertia_rails.rb").to_s

        say "Installing Inertia npm packages"
        add_packages(*FRAMEWORKS[framework][:packages])
        add_packages("--save-dev", *FRAMEWORKS[framework][:dev_packages])

        unless File.read(vite_config_path).include?(FRAMEWORKS[framework][:vite_plugin_import])
          say "Adding Vite plugin for #{framework}"
          insert_into_file vite_config_path, "\n    #{FRAMEWORKS[framework][:vite_plugin_call]},", after: "plugins: ["
          prepend_file vite_config_path, "#{FRAMEWORKS[framework][:vite_plugin_import]}\n"
        end

        unless Rails.root.join("package.json").read.include?('"type": "module"')
          say 'Add "type": "module", to the package.json file'
          gsub_file Rails.root.join("package.json").to_s, /\A\s*\{/, "{\n  \"type\": \"module\","
        end

        say "Copying inertia.js into Vite entrypoints", :blue
        template "#{framework}/inertia.js", Rails.root.join("#{root_path}/entrypoints/inertia.js").to_s

        say "Adding inertia.js script tag to the application layout"
        headers = <<-ERB
    <%= vite_javascript_tag 'inertia' %>

    <%= inertia_headers %>
        ERB
        insert_into_file APPLICATION_LAYOUT.to_s, headers, after: "<%= vite_client_tag %>\n"

        if framework == "react" && !APPLICATION_LAYOUT.read.include?("vite_react_refresh_tag")
          say "Adding Vite React Refresh tag to the application layout"
          insert_into_file APPLICATION_LAYOUT.to_s, "<%= vite_react_refresh_tag %>\n    ", before: "<%= vite_client_tag %>"
          gsub_file APPLICATION_LAYOUT.to_s, /<title>/, "<title inertia>"
        end

        say "Copying example Inertia controller"
        template "controller.rb", Rails.root.join("app/controllers/inertia_example_controller.rb").to_s

        say "Adding a route for the example Inertia controller"
        route "get 'inertia-example', to: 'inertia_example#index'"

        say "Copying framework related files"
        FRAMEWORKS[framework][:copy_files].each do |source, destination|
          template "#{framework}/#{source}", Rails.root.join(destination).to_s
        end
      end

      def ruby_vite?
        Rails.root.join("config/vite.json").exist? && vite_config_path
      end

      def package_manager
        return @package_manager if defined?(@package_manager)

        @package_manager = detect_package_manager
      end

      def add_packages(*packages)
        run "#{package_manager} add #{packages.join(" ")}"
      end

      def detect_package_manager
        return nil unless Rails.root.join("package.json").exist?

        if Rails.root.join("package-lock.json").exist?
          "npm"
        elsif Rails.root.join("bun.config.js").exist?
          "bun"
        else
          "yarn"
        end
      end

      def vite_config_path
        @vite_config_path ||= Dir.glob(Rails.root.join("vite.config.{ts,js,mjs,cjs}")).first
      end

      def framework
        @framework ||= ask("What framework do you want to use with Inertia?", limited_to: FRAMEWORKS.keys, default: "react")
      end

      def root_path
        (defined?(ViteRuby) ? ViteRuby.config.source_code_dir : "app/frontend")
      end
    end
  end
end
