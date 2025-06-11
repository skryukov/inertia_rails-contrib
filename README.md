# InertiaRailsContrib

> Community documentation and generators has been upstreamed to the [Inertia Rails repository](https://github.com/inertiajs/inertia-rails).
>
> Please visit the official Inertia Rails documentation at https://inertia-rails.dev.

From now on we're planning to use `InertiaRailsContrib` as a playground for new features and ideas.
The gem will be updated with new features and improvements, and then the most successful ones will be proposed to the core Inertia Rails repository.

Future plans:
- Ruby LSP plugin for Inertia Rails
- Modals support

Stay tuned!

<a href="https://evilmartians.com/?utm_source=inertia_rails-contrib&utm_campaign=project_page">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Built by Evil Martians" width="236" height="54">
</a>

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add inertia_rails-contrib

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install inertia_rails-contrib

## InertiaUI Modal Support

`InertiaRailsContrib` provides support for [InertiaUI Modal](https://github.com/inertiaui/modal) in the Rails application.

With InertiaUI Modal, you can easily open any route in a Modal or Slideover without having to change anything about your existing routes or controllers.

By default, InertiaUI Modal doesn't require anything from the Inertia Server Adapters, since it just opens modals without changing the URL.
However, InertiaUI Modal also supports updating the URL when opening a modal (see the docs on why you might want that: https://inertiaui.com/inertia-modal/docs/base-route-url).

### Setup

1. Follow the NPM installation instructions from the [InertiaUI Modal documentation](https://inertiaui.com/inertia-modal/docs/installation#npm-installation).

2. Enable InertiaUI Modal, turn on the `enable_inertia_ui_modal` option in the `inertia_rails_contrib.rb` initializer:

```ruby
InertiaRailsContrib.configure do |config|
  config.enable_inertia_ui_modal = true
end
```

This will add a new render method `inertia_modal` that can be used in the controller actions:

```ruby
class PostsController < ApplicationController
  def new
    render inertia_modal: 'Post/New', props: { post: Post.new }, base_url: posts_path
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skryukov/inertia_rails-contrib.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
