# InertiaRailsContrib

A collection of extensions and developer tools for [Inertia's Rails adapter](https://github.com/inertiajs/inertia-rails).

<a href="https://evilmartians.com/?utm_source=inertia_rails-contrib&utm_campaign=project_page">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Built by Evil Martians" width="236" height="54">
</a>

> Community documentation has been moved to the [Inertia Rails repository](https://github.com/inertiajs/inertia-rails).
>
> Please visit the official Inertia Rails documentation at https://inertia-rails.dev.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add inertia_rails-contrib

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install inertia_rails-contrib

## Usage

### Installation generator

`InertiaRailsContrib` comes with a generator that installs and sets up Inertia in a Rails application. It automatically detects if the [Vite Rails](https://vite-ruby.netlify.app/guide/rails.html) gem is installed and will attempt to install it if not present.

To install and setup Inertia in a Rails application, execute the following command in the terminal:

```bash
bundle add inertia_rails-contrib
bin/rails generate inertia:install
```

This command will:
- Check for Vite Rails and install it if not present
- Ask if you want to use TypeScript
- Ask you to choose your preferred frontend framework (React, Vue, Svelte 4, or Svelte 5)
- Ask if you want to install Tailwind CSS
- Install necessary dependencies
- Set up the application to work with Inertia
- Copy example Inertia controller and views (can be skipped with the `--skip-example` option)

Example output:

```bash
$ bin/rails generate inertia:install
Installing Inertia's Rails adapter
Could not find a package.json file to install Inertia to.
Would you like to install Vite Ruby? (y/n) y
         run  bundle add vite_rails from "."
Vite Rails gem successfully installed
         run  bundle exec vite install from "."
Vite Rails successfully installed
Would you like to use TypeScript? (y/n) y
Adding TypeScript support
What framework do you want to use with Inertia? [react, vue, svelte4, svelte] (react)
         run  npm add @types/react @types/react-dom typescript --silent from "."
Would you like to install Tailwind CSS? (y/n) y
Installing Tailwind CSS
         run  npm add tailwindcss postcss autoprefixer @tailwindcss/forms @tailwindcss/typography @tailwindcss/container-queries --silent from "."
      create  tailwind.config.js
      create  postcss.config.js
      create  app/frontend/entrypoints/application.css
Adding Tailwind CSS to the application layout
      insert  app/views/layouts/application.html.erb
Adding Inertia's Rails adapter initializer
      create  config/initializers/inertia_rails.rb
Installing Inertia npm packages
         run  npm add @vitejs/plugin-react react react-dom --silent from "."
         run  npm add @inertiajs/react@latest --silent from "."
Adding Vite plugin for react
      insert  vite.config.ts
     prepend  vite.config.ts
Copying inertia.ts entrypoint
      create  app/frontend/entrypoints/inertia.ts
Adding inertia.ts script tag to the application layout
      insert  app/views/layouts/application.html.erb
Adding Vite React Refresh tag to the application layout
      insert  app/views/layouts/application.html.erb
        gsub  app/views/layouts/application.html.erb
Copying example Inertia controller
      create  app/controllers/inertia_example_controller.rb
Adding a route for the example Inertia controller
       route  get 'inertia-example', to: 'inertia_example#index'
Copying page assets
      create  app/frontend/pages/InertiaExample.module.css
      create  app/frontend/assets/react.svg
      create  app/frontend/assets/inertia.svg
      create  app/frontend/assets/vite_ruby.svg
      create  app/frontend/pages/InertiaExample.tsx
      create  tsconfig.json
      create  tsconfig.app.json
      create  tsconfig.node.json
      create  app/frontend/vite-env.d.ts
Copying bin/dev
      create  bin/dev
Inertia's Rails adapter successfully installed
```

With that done, you can now start the Rails server and the Vite development server (we recommend using [Overmind](https://github.com/DarthSim/overmind)):

```bash
bin/dev
```

And navigate to `http://localhost:3100/inertia-example` to see the example Inertia page.

### Scaffold generator

`InertiaRailsContrib` also comes with a scaffold generator that generates a new resource with Inertia responses. To use it, execute the following command in the terminal:

```bash
bin/rails generate inertia:scaffold ModelName field1:type field2:type
```

Example output:

```bash
$ bin/rails generate inertia:scaffold Post title:string body:text
      invoke  active_record
      create    db/migrate/20240611123952_create_posts.rb
      create    app/models/post.rb
      invoke    test_unit
      create      test/models/post_test.rb
      create      test/fixtures/posts.yml
      invoke  resource_route
       route    resources :posts
      invoke  scaffold_controller
      create    app/controllers/posts_controller.rb
      invoke    inertia_templates
      create      app/frontend/pages/Post
      create      app/frontend/pages/Post/Index.svelte
      create      app/frontend/pages/Post/Edit.svelte
      create      app/frontend/pages/Post/Show.svelte
      create      app/frontend/pages/Post/New.svelte
      create      app/frontend/pages/Post/Form.svelte
      create      app/frontend/pages/Post/Post.svelte
      invoke    resource_route
      invoke    test_unit
      create      test/controllers/posts_controller_test.rb
      create      test/system/posts_test.rb
      invoke    helper
      create      app/helpers/posts_helper.rb
      invoke      test_unit
```

#### Tailwind CSS integration

`InertiaRailsContrib` tries to detect the presence of Tailwind CSS in the application and generate the templates accordingly. If you want to specify templates type, use the `--inertia-templates` option:

- `inertia_templates` - default
- `inertia_tw_templates` - Tailwind CSS

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/skryukov/inertia_rails-contrib.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
