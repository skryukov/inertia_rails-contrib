# Responses

## Creating responses

Creating an Inertia response is simple. To get started, just use the `inertia` renderer in your controller methods, providing both the name of the [JavaScript page component](/guide/pages.md) that you wish to render, as well as any props (data) for the page.

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

Within Rails applications, the `Event/Show` page would typically correspond to the file located at `app/frontend/pages/User/Show.(jsx|vue|svelte)`.

> [!WARNING]
> To ensure that pages load quickly, only return the minimum data required for the page. Also, be aware that **all data returned from the controllers will be visible client-side**, so be sure to omit sensitive information.

### Using instance variables as props

Inertia enables the automatic passing of instance variables as props. This can be achieved by invoking the `use_inertia_instance_props` function in a controller or in a base controller from which other controllers inherit.

```ruby
class EventsController < ApplicationController
  use_inertia_instance_props

  def index
    @events = Event.all

    render inertia: 'Events/Index'
  end
end
```

This action automatically passes the `@events` instance variable as the `events` prop to the `Events/Index` page component.

> [!NOTE]
> Manually providing any props for a response disables the instance props feature for that specific response.

> [!NOTE]
> Instance props are only included if they are defined **after** the `use_inertia_instance_props` call, hence the order of `before_action` callbacks is crucial.

### Automatically determine component name

Rails conventions can be used to automatically render the correct page component by invoking `render inertia: true`:

```ruby
class EventsController < ApplicationController
  use_inertia_instance_props

  def index
    @events = Event.all

    render inertia: true
  end
end
```
This renders the `app/frontend/pages/events/index.(jsx|vue|svelte)` page component and passes the `@events` instance variable as the `events` prop.


Setting the `default_render` configuration value to `true` establishes this as the default behavior:

```ruby
InertiaRails.configure do |config|
  config.default_render = true
end
```

```ruby
class EventsController < ApplicationController
  use_inertia_instance_props
  
  def index
    @events = Event.all
  end
end
```

With this configuration, the `app/frontend/pages/events/index.(jsx|vue|svelte)` page component is rendered automatically, passing the `@events` instance variable as the `events` prop.

## Root template data

There are situations where you may want to access your prop data in your ERB template. For example, you may want to add a meta description tag, Twitter card meta tags, or Facebook Open Graph meta tags. You can access this data via the `page` method.

```erb
# app/views/inertia.html.erb

<% content_for(:head) do %>
<meta name="twitter:title" content="<%= page["props"]["event"].title %>">
<% end %>

<div id="app" data-page="<%= page.to_json %>"></div>
```

Sometimes you may even want to provide data to the root template that will not be sent to your JavaScript page / component. This can be accomplished by passing the `view_data` option.

```ruby
def show
  event = Event.find(params[:id])

  render inertia: 'Event', props: { event: }, view_data: { meta: event.meta }
end
```

You can then access this variable like a regular local variable.

```erb
# app/views/inertia.html.erb

<% content_for(:head) do %>
<meta
  name="description"
  content="<%= local_assigns.fetch(:meta, "Default description") %>">
<% end %>

<div id="app" data-page="<%= page.to_json %>"></div>
```

## Maximum response size

To enable client-side history navigation, all Inertia server responses are stored in the browser's history state. However, keep in mind that some browsers impose a size limit on how much data can be saved within the history state.

For example, [Firefox](https://developer.mozilla.org/en-US/docs/Web/API/History/pushState) has a size limit of 640k characters and throws a `NS_ERROR_ILLEGAL_VALUE` error if you exceed this limit. Typically, this is much more data than you'll ever practically need when building applications.
