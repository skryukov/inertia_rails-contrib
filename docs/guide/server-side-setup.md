# Server-side setup

The first step when installing Inertia is to configure your server-side framework. Inertia maintains official server-side adapters for [Laravel](https://laravel.com) and [Ruby on Rails](https://rubyonrails.org). For other frameworks, please see the [community adapters](https://inertiajs.com/community-adapters).

> [!NOTE]
> For the official Laravel adapter instructions, please see the [official documentation](https://inertiajs.com/server-side-setup).

## Install dependencies

First, install the Inertia server-side adapter gem and add to the application's Gemfile by executing:

```bash
bundle add inertia_rails
```

## Rails generator

If you plan to use Vite as your frontend build tool, you can use the `inertia_rails-contrib` gem to install and set up Inertia in a Rails application. **It requires the [Vite Rails](https://vite-ruby.netlify.app/guide/rails.html) gem to be installed and configured in the application.**

To use the generator, execute the following command in the terminal:

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
What framework do you want to use with Inertia? [react, vue, svelte] (react)
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

That's it! You're all set up to start using Inertia in your Rails application. Check the guide on [creating pages](/guide/pages) to know more.

## Root template

If you decide not to use the generator, you can manually set up Inertia in your Rails application.

First, setup the root template that will be loaded on the first page visit. This will be used to load your site assets (CSS and JavaScript), and will also contain a root `<div>` to boot your JavaScript application in.

:::tabs key:builders
== Vite

```erb
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csp_meta_tag %>

    <%= inertia_headers %>

    <%# If you want to use React add `vite_react_refresh_tag` %>
    <%= vite_client_tag %>
    <%= vite_javascript_tag 'application' %>
  </head>

  <body>
    <%= yield %>
  </body>
</html>
```

== Webpacker/Shakapacker

```erb
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <%= csp_meta_tag %>

    <%= inertia_headers %>

    <%= stylesheet_pack_tag 'application' %>
    <%= javascript_pack_tag 'application', defer: true %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

:::

This template should include your assets, as well as the `yield` method to render the Inertia page. The `inertia_headers` method is used to include the Inertia headers in the response, it's required when [SSR](/guide/server-side-rendering.md) is enabled.

Inertia's adapter will use standard Rails layout inheritance, with `view/layouts/application.html.erb` as a default layout. If you would like to use a different default layout, you can change it using the `InertiaRails.configure`.

```ruby
# config/initializers/inertia_rails.rb
InertiaRails.configure do |config|
  config.layout = 'my_inertia_layout'
end
```

# Creating responses

That's it, you're all ready to go server-side! Once you setup the [client-side](/guide/client-side-setup.md) framework, you can start start creating Inertia [pages](/guide/pages.md) and rendering them via [responses](/guide/responses.md).

```ruby
class EventsController < ApplicationController
  def show
    event = Event.find(params[:id])

    render inertia: 'Event/Show', props: {
      event: event.as_json(
        only: [:id, :title, :start_date, :description]
      )
    }
  end
end
```
