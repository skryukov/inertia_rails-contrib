# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog],
and this project adheres to [Semantic Versioning].

## [Unreleased]

## [0.2.1] - 2024-08-11

Added:

- Support `pnpm` package manager ([@skryukov])
- New `--verbose` option for the installation generator ([@skryukov])

Fixed:

- Support installation alongside Webpacker ([@skryukov])

## [0.2.0] - 2024-08-10

Added:

- Improve installation generator ([@skryukov])
  - option to install Vite Rails gem (`--install-vite`)
  - option to install Tailwind CSS (`--install-tailwind`)
  - option to install without interactivity (`--no-interaction` & `--framework=react|vue|svelte`)
  - option to skip example page generation (`--no-example-page`)
  - option to choose package manager (`--package-manager=yarn|npm|bun`)
  - generate `bin/dev`

## [0.1.1] - 2024-06-17

### Fixed:

- Add a missing bracket to the `React/Edit` template. ([@skryukov]) 

## [0.1.0] - 2024-06-11

- Initial release ([@iurev], [@skryukov])

[@iurev]: https://github.com/iurev
[@skryukov]: https://github.com/skryukov

[Unreleased]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/skryukov/inertia_rails-contrib/commits/v0.1.0

[Keep a Changelog]: https://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
