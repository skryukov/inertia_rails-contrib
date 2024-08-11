require "yaml"
require "rails/generators"
require "rails/generators/base"

require_relative "helpers"

module Inertia
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Helpers

      FRAMEWORKS = YAML.load_file(File.expand_path("./frameworks.yml", __dir__))

      source_root File.expand_path("./templates", __dir__)

      class_option :framework, type: :string,
        desc: "The framework you want to use with Inertia",
        enum: FRAMEWORKS.keys,
        default: nil

      class_option :package_manager, type: :string, default: nil, enum: %w[npm yarn bun pnpm],
        desc: "The package manager you want to use to install Inertia's npm packages"

      class_option :interactive, type: :boolean, default: true,
        desc: "Whether to prompt for optional installations"

      class_option :install_tailwind, type: :boolean, default: false,
        desc: "Whether to install Tailwind CSS"
      class_option :install_vite, type: :boolean, default: false,
        desc: "Whether to install Vite Ruby"
      class_option :example_page, type: :boolean, default: true,
        desc: "Whether to add an example Inertia page"

      class_option :verbose, type: :boolean, default: false,
        desc: "Run the generator in verbose mode"

      remove_class_option :skip_namespace, :skip_collision_check

      def install
        say "Installing Inertia's Rails adapter"

        install_vite unless ruby_vite_installed?

        install_tailwind if install_tailwind?

        install_inertia

        install_example_page if options[:example_page]

        say "Copying bin/dev"
        copy_file "#{__dir__}/templates/dev", "bin/dev"
        chmod "bin/dev", 0o755, verbose: verbose?

        say "Inertia's Rails adapter successfully installed", :green
      end

      private

      def install_inertia
        say "Adding Inertia's Rails adapter initializer"
        template "initializer.rb", file_path("config/initializers/inertia_rails.rb")

        say "Installing Inertia npm packages"
        add_packages(*FRAMEWORKS[framework]["packages"])

        unless File.read(vite_config_path).include?(FRAMEWORKS[framework]["vite_plugin_import"])
          say "Adding Vite plugin for #{framework}"
          insert_into_file vite_config_path, "\n    #{FRAMEWORKS[framework]["vite_plugin_call"]},", after: "plugins: ["
          prepend_file vite_config_path, "#{FRAMEWORKS[framework]["vite_plugin_import"]}\n"
        end

        say "Copying inertia.js entrypoint"
        template "#{framework}/inertia.js", js_file_path("entrypoints/inertia.js")

        if application_layout.exist?
          say "Adding inertia.js script tag to the application layout"
          headers = <<-ERB
    <%= vite_javascript_tag "inertia" %>
    <%= inertia_headers %>
          ERB
          headers += "\n      <%= vite_stylesheet_tag \"application\" %>" if install_tailwind?

          insert_into_file application_layout.to_s, headers, after: "<%= vite_client_tag %>\n"

          if framework == "react" && !application_layout.read.include?("vite_react_refresh_tag")
            say "Adding Vite React Refresh tag to the application layout"
            insert_into_file application_layout.to_s, "<%= vite_react_refresh_tag %>\n    ", before: "<%= vite_client_tag %>"
            gsub_file application_layout.to_s, /<title>/, "<title inertia>"
          end
        else
          say_error "Could not find the application layout file. Please add the following tags manually:", :red
          say_error "-  <title>...</title>"
          say_error "+  <title inertia>...</title>"
          say_error "+  <%= inertia_headers %>"
          say_error "+  <%= vite_react_refresh_tag %>" if framework == "react"
          say_error "+  <%= vite_javascript_tag \"inertia\" %>"
        end
      end

      def install_example_page
        say "Copying example Inertia controller"
        template "controller.rb", file_path("app/controllers/inertia_example_controller.rb")

        say "Adding a route for the example Inertia controller"
        route "get 'inertia-example', to: 'inertia_example#index'"

        say "Copying page assets"
        FRAMEWORKS[framework]["copy_files"].each do |source, destination|
          template "#{framework}/#{source}", file_path(destination % {js_destination_path: js_destination_path})
        end
      end

      def install_tailwind
        say "Installing Tailwind CSS"
        add_packages(%w[tailwindcss postcss autoprefixer @tailwindcss/forms @tailwindcss/typography @tailwindcss/container-queries])

        template "tailwind/tailwind.config.js", file_path("tailwind.config.js")
        copy_file "tailwind/postcss.config.js", file_path("postcss.config.js")
        copy_file "tailwind/application.css", js_file_path("entrypoints/application.css")

        if application_layout.exist?
          say "Adding Tailwind CSS to the application layout"
          insert_into_file application_layout.to_s, "<%= vite_stylesheet_tag \"application\" %>\n    ", before: "<%= vite_client_tag %>"
        else
          say_error "Could not find the application layout file. Please add the following tags manually:", :red
          say_error "+  <%= vite_stylesheet_tag \"application\" %>" if install_tailwind?
        end
      end

      def install_vite
        unless install_vite?
          say_error "This generator only supports Ruby on Rails with Vite.", :red
          exit(false)
        end

        in_root do
          Bundler.with_original_env do
            if (capture = run("bundle add vite_rails", capture: !verbose?))
              say "Vite Rails gem successfully installed", :green
            else
              say capture
              say_error "Failed to install Vite Rails gem", :red
              exit(false)
            end
            if (capture = run("bundle exec vite install", capture: !verbose?))
              say "Vite Rails successfully installed", :green
            else
              say capture
              say_error "Failed to install Vite Rails", :red
              exit(false)
            end
          end
        end
      end

      def ruby_vite_installed?
        return true if package_manager && ruby_vite?

        if package_manager.nil?
          say_status "Could not find a package.json file to install Inertia to.", nil
        else
          say_status "Could not find a Vite configuration files (`config/vite.json` & `vite.config.{ts,js,mjs,cjs}`).", nil
        end
        false
      end

      def application_layout
        @application_layout ||= Pathname.new(file_path("app/views/layouts/application.html.erb"))
      end

      def ruby_vite?
        file?("config/vite.json") && vite_config_path
      end

      def package_manager
        options[:package_manager] || detect_package_manager
      end

      def add_packages(*packages)
        in_root do
          run "#{package_manager} add #{packages.join(" ")} #{verbose? ? "" : "--silent"}"
        end
      end

      def detect_package_manager
        return nil unless file?("package.json")

        if file?("package-lock.json")
          "npm"
        elsif file?("bun.lockb")
          "bun"
        elsif file?("pnpm-lock.yaml")
          "pnpm"
        else
          "yarn"
        end
      end

      def vite_config_path
        @vite_config_path ||= Dir.glob(file_path("vite.config.{ts,js,mjs,cjs}")).first
      end

      def install_vite?
        return @install_vite if defined?(@install_vite)

        @install_vite = options[:install_vite] || yes?("Would you like to install Vite Ruby? (y/n)", :green)
      end

      def install_tailwind?
        return @install_tailwind if defined?(@install_tailwind)

        @install_tailwind = options[:install_tailwind] || yes?("Would you like to install Tailwind CSS? (y/n)", :green)
      end

      def verbose?
        options[:verbose]
      end

      def framework
        @framework ||= options[:framework] || ask("What framework do you want to use with Inertia?", :green, limited_to: FRAMEWORKS.keys, default: "react")
      end
    end
  end
end
