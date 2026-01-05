# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog],
and this project adheres to [Semantic Versioning].

## [Unreleased]

## [0.5.2] - 2026-01-05

### Fixed:

- Return the modal ID in InertiaUI Modal responses ([@nicklozon])

## [0.5.1] - 2025-07-31

### Fixed:

- Fix params mismatch error when base URL uses other param names ([@skryukov])

## [0.5.0] - 2025-06-11

### Added:

- [InertiaUI Modal](https://github.com/inertiaui/modal) support ([@skryukov])

## [0.4.0] - 2024-12-23

### Changed:

- Generators are upstreamed to the `inertia_rails` gem ([@skryukov])

## [0.3.0] - 2024-10-25

### Added:

- [BREAKING] Svelte 5 support ([@skryukov])
  - The `--framework=svelte` option now installs Svelte 5
  - New `--framework=svelte4` option installs Svelte 4
  - Support for Svelte 5 in the installation generator
  - Support for Svelte 5 in the scaffold templates

## [0.2.2] - 2024-10-09

### Added:

- TypeScript support for the installation generator ([@skryukov])
  Note that it doesn't include scaffold templates yet.

- New `--inertia-version` option for the installation generator ([@skryukov])
  This allows you to specify the Inertia.js version to install.

- Support `tailwind.config.ts` for Tailwind CSS template guessing ([@Shaglock])

### Fixed:

- Correct examples for default layouts in inertia entrypoints ([@skryukov])
- Inertia attribute added to the head tag in the layout for vue ([@skryukov])
- Remove duplicate `vite_stylesheet_tag` when Tailwind CSS is installed ([@skryukov])

## [0.2.1] - 2024-08-11

### Added:

- Support `pnpm` package manager ([@skryukov])
- New `--verbose` option for the installation generator ([@skryukov])

### Fixed:

- Support installation alongside Webpacker ([@skryukov])

## [0.2.0] - 2024-08-10

### Added:

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

### Added:

- Initial release ([@iurev], [@skryukov])

[@iurev]: https://github.com/iurev
[@nicklozon]: https://github.com/nicklozon
[@Shaglock]: https://github.com/Shaglock
[@skryukov]: https://github.com/skryukov

[Unreleased]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.5.2...HEAD
[0.5.2]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.5.1...v0.5.2
[0.5.1]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.5.0...v0.5.1
[0.5.0]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/skryukov/inertia_rails-contrib/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/skryukov/inertia_rails-contrib/commits/v0.1.0

[Keep a Changelog]: https://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html
