# frozen_string_literal: true

require_relative "lib/inertia_rails_contrib/version"

Gem::Specification.new do |spec|
  spec.name = "inertia_rails-contrib"
  spec.version = InertiaRailsContrib::VERSION
  spec.authors = ["Svyatoslav Kryukov"]
  spec.email = ["me@skryukov.dev"]

  spec.summary = "A collection of extensions and developer tools for Rails Inertia adapter"
  spec.description = "A collection of extensions and developer tools for Rails Inertia adapter"
  spec.homepage = "https://github.com/skryukov/inertia_rails-contrib"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "documentation_uri" => "#{spec.homepage}/blob/main/README.md",
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir["{app,lib}/**/*", "CHANGELOG.md", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "railties", ">= 6.0.0"
  spec.add_dependency "inertia_rails"
end
