# InertiaRailsContrib

A collection of extensions, developer tools, and the [community documentation](https://inertia-rails.netlify.app) for [Inertia's Rails adapter](https://github.com/inertiajs/inertia-rails).

<a href="https://evilmartians.com/?utm_source=inertia_rails-contrib&utm_campaign=project_page">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Built by Evil Martians" width="236" height="54">
</a>

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add inertia_rails-contrib

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install inertia_rails-contrib

## Usage

### Installation generator

`InertiaRailsContrib` comes with a generator that installs and sets up Inertia in a Rails application. **It requires the [Vite Ruby](https://vite-ruby.netlify.app) gem to be installed and configured in the application.**

<details>
<summary>Creating a new Rails application and configuring Vite</summary>

This is actually a simple process. First, create a new Rails application:
```bash
rails new myapp --skip-js
```

Next, install the Vite Ruby gem:

```bash
bundle add vite_ruby
bundle exec vite install
```

If you use macOS, you may need to edit the `config/vite.rb` file to add the following line:

```json
{
  "development": {
+ "host": "127.0.0.1",
  "autoBuild": true,
  "publicOutputDir": "vite-dev",
  "port": 3036
  }
}
```

That's it! Vite is now installed and configured in the Rails application. For more information, refer to the [Vite Ruby documentation](https://vite-ruby.netlify.app) and the [Vite-lizing Rails: get live reload and hot replacement with Vite Ruby](https://evilmartians.com/chronicles/vite-lizing-rails-get-live-reload-and-hot-replacement-with-vite-ruby) article.

The next step is to install Inertia!
</details>

To install and setup Inertia in a Rails application, execute the following command in the terminal:

```bash
bundle add inertia_rails-contrib
bin/rails generate inertia:install
```

This command will ask you for the frontend framework you are using (React, Vue, or Svelte) and will install the necessary dependencies and set up the application to work with Inertia.

Example output:

```bash
$ bin/rails generate inertia:install

Installing Inertia's Rails adapter
Adding Inertia's Rails adapter initializer
      create  config/initializers/inertia_rails.rb
Installing Inertia npm packages
What framework do you want to use with Turbo Mount? [react, vue, svelte] (react)
         run  npm add @inertiajs/inertia @inertiajs/react react react-dom from "."

added 6 packages, removed 42 packages, and audited 69 packages in 8s

18 packages are looking for funding
  run `npm fund` for details

2 moderate severity vulnerabilities

Some issues need review, and may require choosing
a different dependency.

Run `npm audit` for details.
         run  npm add --save-dev @vitejs/plugin-react from "."

added 58 packages, and audited 127 packages in 6s

22 packages are looking for funding
  run `npm fund` for details

2 moderate severity vulnerabilities

Some issues need review, and may require choosing
a different dependency.

Run `npm audit` for details.
Adding Vite plugin for react
      insert  vite.config.ts
     prepend  vite.config.ts
Add "type": "module", to the package.json file
        gsub  package.json
Copying inertia.js into Vite entrypoints
      create  app/frontend/entrypoints/inertia.js
Adding inertia.js script tag to the application layout
      insert  app/views/layouts/application.html.erb
Adding Vite React Refresh tag to the application layout
      insert  app/views/layouts/application.html.erb
Copying example Inertia controller
      create  app/controllers/inertia_example_controller.rb
Adding a route for the example Inertia controller
       route  get 'inertia-example', to: 'inertia_example#index'
Copying framework related files
      create  app/frontend/pages/InertiaExample.jsx
Inertia's Rails adapter successfully installed
```

With that done, you can now start the Rails server and the Vite development server (we recommend using [Overmind](https://github.com/DarthSim/overmind)):

```bash
overmind start -f Procfile.dev
# or
foreman start -f Procfile.dev
```

And navigate to `http://127.0.0.1:5100/inertia-example` to see the example Inertia page.

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
