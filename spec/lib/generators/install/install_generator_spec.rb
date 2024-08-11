require_relative "../../../../lib/generators/inertia/install/install_generator"
require "generator_spec"

RSpec.describe Inertia::Generators::InstallGenerator, type: :generator do
  destination File.expand_path("../../../../../tmp", __FILE__)

  let(:args) { %W[--framework=#{framework} --no-interactive -q] }
  let(:framework) { :react }

  subject(:generator) { run_generator(args) }

  context "without vite" do
    before do
      prepare_application(with_vite: false)
    end

    it "exits with an error" do
      expect { generator }.to raise_error(SystemExit)
    end

    context "with --install-vite" do
      let(:args) { super() + %w[--install-vite] }

      it "installs Vite" do
        expect { generator }.not_to raise_error
        expect_example_page_for(:react)
        expect_packages_for(:react)
        expect(destination_root).to(have_structure do
          directory("app/frontend") do
            no_file("entrypoints/application.css")
          end
          no_file("postcss.config.js")
          no_file("tailwind.config.js")
        end)
      end
    end
  end

  context "with --install-tailwind" do
    let(:args) { super() + %w[--install-tailwind] }

    before { prepare_application }

    it "installs Tailwind" do
      expect { generator }.not_to raise_error
      expect_tailwind_config
    end
  end

  context "with --framework=svelte" do
    let(:framework) { :svelte }

    before { prepare_application }

    it "installs the Inertia adapter" do
      expect { generator }.not_to raise_error

      expect_example_page_for(framework)
      expect_inertia_prepared_for(framework)
      expect_packages_for(framework)
    end
  end

  context "with --framework=vue" do
    let(:framework) { :vue }

    before { prepare_application }

    it "installs the Inertia adapter" do
      expect { generator }.not_to raise_error

      expect_example_page_for(framework)
      expect_inertia_prepared_for(framework)
      expect_packages_for(framework)
    end
  end

  context "with --framework=react" do
    let(:framework) { :react }

    before { prepare_application }

    it "installs the Inertia adapter" do
      expect { generator }.not_to raise_error

      expect_example_page_for(framework)
      expect_inertia_prepared_for(framework)
      expect_packages_for(framework)
    end
  end

  context "with yarn" do
    before { prepare_application }

    it "installs the Inertia adapter" do
      expect { generator }.not_to raise_error

      expect_example_page_for(:react)
      expect_packages_for(:react)
      expect(destination_root).to(have_structure do
        file("yarn.lock")
      end)
    end
  end

  context "with npm" do
    let(:args) { super() + %w[--package-manager=npm] }

    before { prepare_application }

    it "installs the Inertia adapter" do
      expect { generator }.not_to raise_error

      expect_example_page_for(:react)
      expect_packages_for(:react)
      expect(destination_root).to(have_structure do
        file("package-lock.json")
      end)
    end
  end

  context "with pnpm" do
    let(:args) { super() + %w[--package-manager=pnpm] }

    before { prepare_application }

    it "installs the Inertia adapter" do
      expect { generator }.not_to raise_error

      expect_example_page_for(:react)
      expect_packages_for(:react)
      expect(destination_root).to(have_structure do
        file("pnpm-lock.yaml")
      end)
    end
  end

  context "with bun" do
    let(:args) { super() + %w[--package-manager=bun] }

    before { prepare_application }

    it "installs the Inertia adapter" do
      expect { generator }.not_to raise_error

      expect_example_page_for(:react)
      expect_packages_for(:react)
      expect(destination_root).to(have_structure do
        file("bun.lockb")
      end)
    end
  end

  def prepare_application(with_vite: true)
    prepare_destination
    FileUtils.cp_r(Dir["spec/fixtures/dummy/*"], destination_root)
    FileUtils.cp_r(Dir["spec/fixtures/with_vite/*"], destination_root) if with_vite
  end

  def expect_tailwind_config
    expect(destination_root).to(have_structure do
      directory("app/frontend") do
        file("entrypoints/application.css")
      end
      file("postcss.config.js")
      file("tailwind.config.js")
    end)
  end

  def expect_vite_config
    expect(destination_root).to(have_structure do
      directory("config") do
        file("vite.json")
      end
      file("vite.config.js")
    end)
  end

  def expect_packages_for(framework)
    expect(destination_root).to(have_structure do
      file("package.json") do
        case framework
        when :react
          contains('"@inertiajs/react":')
          contains('"react":')
          contains('"react-dom":')
          contains('"@vitejs/plugin-react":')
        when :vue
          contains('"@inertiajs/vue3":')
          contains('"vue":')
          contains('"@vitejs/plugin-vue":')
        when :svelte
          contains('"@inertiajs/svelte":')
          contains('"svelte":')
          contains('"@sveltejs/vite-plugin-svelte":')
        end
      end
    end)
  end

  def expect_inertia_prepared_for(framework)
    expect(destination_root).to(have_structure do
      case framework
      when :react
        file("vite.config.ts") do
          contains("react()")
        end
        file("app/frontend/entrypoints/inertia.js") do
          contains("import { createInertiaApp } from '@inertiajs/react'")
        end
      when :vue
        file("vite.config.ts") do
          contains("vue()")
        end
        file("app/frontend/entrypoints/inertia.js") do
          contains("import { createInertiaApp } from '@inertiajs/vue3'")
        end
      when :svelte
        file("svelte.config.js") do
          contains("preprocess: vitePreprocess()")
        end
        file("vite.config.ts") do
          contains("svelte()")
        end
        file("app/frontend/entrypoints/inertia.js") do
          contains("import { createInertiaApp } from '@inertiajs/svelte'")
        end
      end
      file("app/views/layouts/application.html.erb") do
        contains('<%= vite_javascript_tag "inertia" %>')
        if framework == :react
          contains("<%= vite_react_refresh_tag %>")
        else
          does_not_contain("<%= vite_react_refresh_tag %>")
        end
      end
      file("config/initializers/inertia_rails.rb") do
        contains("config.version = ViteRuby.digest")
      end

      file("bin/dev") do
        contains("overmind start -f Procfile.dev")
      end
    end)
  end

  def expect_example_page_for(framework)
    expect(destination_root).to(have_structure do
      directory("app/frontend") do
        case framework
        when :react
          file("pages/InertiaExample.jsx")
          file("pages/InertiaExample.module.css")
          file("assets/react.svg")
        when :vue
          file("pages/InertiaExample.vue")
          file("assets/vue.svg")
        when :svelte
          file("pages/InertiaExample.svelte")
          file("assets/svelte.svg")
        end

        file("assets/inertia.svg")
        file("assets/vite_ruby.svg")
      end
    end)
  end
end
