# Links

To create links to other pages within an Inertia app, you will typically use the Inertia `<Link>` component. This component is a light wrapper around a standard anchor `<a>` link that intercepts click events and prevents full page reloads. This is [how Inertia provides a single-page app experience](/guide/how-it-works.md) once your application has been loaded.

## Creating links

To create an Inertia link, use the Inertia `<Link>` component. Any attributes you provide to this component will be proxied to the underlying HTML tag.

:::tabs key:frameworks

== Vue 2

```vue
import { Link } from '@inertiajs/vue2'

<Link href="/">Home</Link>
```

== Vue 3

```vue
import { Link } from '@inertiajs/vue3'

<Link href="/">Home</Link>
```

== React

```jsx
import { Link } from '@inertiajs/react'

<Link href="/">Home</Link>
```

== Svelte

```svelte
import { inertia, Link } from '@inertiajs/svelte'

<a href="/" use:inertia>Home</a>

<Link href="/">Home</Link>
```

> [!TIP]
> The `use:inertia` directive can be applied to any HTML element.

:::

By default, Inertia renders links as anchor `<a>` elements. However, you can change the tag using the `as` prop.

:::tabs key:frameworks
== Vue 2

```vue
import { Link } from '@inertiajs/vue2'

<Link href="/logout" method="post" as="button" type="button">Logout</Link>

// Renders as...
<button type="button">Logout</button>
```

== Vue 3

```vue
import { Link } from '@inertiajs/vue3'

<Link href="/logout" method="post" as="button" type="button">Logout</Link>

// Renders as...
<button type="button">Logout</button>
```

== React

```jsx
import { Link } from '@inertiajs/react'

<Link href="/logout" method="post" as="button" type="button">Logout</Link>

// Renders as...
<button type="button">Logout</button>
```

== Svelte

```svelte
import { inertia } from '@inertiajs/svelte'

<button use:inertia="{{ href: '/logout', method: 'post' }}" type="button">Logout</button>

// Renders as...
<button type="button">Logout</button>
```

> [!NOTE]
> Svelte does not support dynamic elements yet, but you can use the `inertia` directive to achieve the same results.

:::

> [!WARNING]
> Creating `POST/PUT/PATCH/DELETE` anchor `<a>` links is discouraged as it causes "Open Link in New Tab / Window" accessibility issues. Instead, consider using a more appropriate element, such as a `<button>`.

## Method

You can specify the HTTP request method for an Inertia link request using the `method` prop. The default method used by links is `GET`, but you can use the `method` prop to make `POST`, `PUT`, `PATCH`, and `DELETE` requests via links.

:::tabs key:frameworks
== Vue 2

```vue
import { Link } from '@inertiajs/vue2'

<Link href="/logout" method="post" as="button">Logout</Link>
```

== Vue 3

```vue
import { Link } from '@inertiajs/vue3'

<Link href="/logout" method="post" as="button">Logout</Link>
```

== React

```jsx
import { Link } from '@inertiajs/react'

<Link href="/logout" method="post" as="button">
  Logout
</Link>
```

== Svelte

```svelte
import { inertia, Link } from '@inertiajs/svelte'

<button use:inertia="{{ href: '/logout', method: 'post' }}" type="button">Logout</button>
```

:::

## Data

When making `POST` or `PUT` requests, you may wish to add additional data to the request. You can accomplish this using the `data` prop. The provided data can be an `object` or `FormData` instance.

:::tabs key:frameworks
== Vue 2

```vue
import { Link } from '@inertiajs/vue2'

<Link
  href="/endpoint"
  method="post"
  as="button"
  :data="{ foo: bar }"
>Save</Link>
```

== Vue 3

```vue
import { Link } from '@inertiajs/vue3'

<Link
  href="/endpoint"
  method="post"
  as="button"
  :data="{ foo: bar }"
>Save</Link>
```

== React

```jsx
import { Link } from '@inertiajs/react'

<Link href="/endpoint" method="post" as="button" data={{ foo: bar }}>
  Save
</Link>
```

== Svelte

```svelte
import { inertia, Link } from '@inertiajs/svelte'

<button use:inertia="{{ href: '/endpoint', method: 'post', data: { foo: bar } }}" type="button">Save</button>

<Link href="/endpoint" method="post" data={{ foo: bar }}>Save</Link>
```

:::

## Custom headers

The `headers` prop allows you to add custom headers to an Inertia link. However, the headers Inertia uses internally to communicate its state to the server take priority and therefore cannot be overwritten.

:::tabs key:frameworks
== Vue 2

```vue
import { Link } from '@inertiajs/vue2'

<Link href="/endpoint" :headers="{ foo: bar }">Save</Link>
```

== Vue 3

```vue
import { Link } from '@inertiajs/vue3'

<Link href="/endpoint" :headers="{ foo: bar }">Save</Link>
```

== React

```jsx
import { Link } from '@inertiajs/react'

<Link href="/endpoint" headers={{ foo: bar }}>
  Save
</Link>
```

== Svelte

```svelte
import { inertia, Link } from '@inertiajs/svelte'

<button use:inertia="{{ href: '/endpoint', headers: { foo: bar } }}">Save</button>

<Link href="/endpoint" headers={{ foo: bar}}>Save</Link>
```

:::

## Browser history

The `replace` prop allows you to specify the browser's history behavior. By default, page visits push (new) state (`window.history.pushState`) into the history; however, it's also possible to replace state (`window.history.replaceState`) by setting the `replace` prop to `true`. This will cause the visit to replace the current history state instead of adding a new history state to the stack.

:::tabs key:frameworks
== Vue 2

```vue
import { Link } from '@inertiajs/vue2'

<Link href="/" replace>Home</Link>
```

== Vue 3

```vue
import { Link } from '@inertiajs/vue3'

<Link href="/" replace>Home</Link>
```

== React

```jsx
import { Link } from '@inertiajs/react'

<Link href="/" replace>
  Home
</Link>
```

== Svelte

```svelte
import { inertia, Link } from '@inertiajs/svelte'

<a href="/" use:inertia="{{ replace: true }}">Home</a>

<Link href="/" replace>Home</Link>
```

:::

## State preservation

You can preserve a page component's local state using the `preserveState` prop. This will prevent a page component from fully re-rendering. The `preserveState` prop is especially helpful on pages that contain forms, since you can avoid manually repopulating input fields and can also maintain a focused input.

:::tabs key:frameworks
== Vue 2

```vue
import { Link } from '@inertiajs/vue2'

<input v-model="query" type="text" />

<Link href="/search" :data="{ query }" preserve-state>Search</Link>
```

== Vue 3

```vue
import { Link } from '@inertiajs/vue3'

<input v-model="query" type="text" />

<Link href="/search" :data="{ query }" preserve-state>Search</Link>
```

== React

```jsx
import { Link } from '@inertiajs/react'

<input onChange={this.handleChange} value={query} />

<Link href="/search" data={query} preserveState>Search</Link>
```

== Svelte

```svelte
import { inertia, Link } from '@inertiajs/svelte'

<input on:change={handleChange} value={query} />

<button use:inertia="{{ href: '/search', data: query, preserveState: true }}">Search</button>

<Link href="/search" data={query} preserveState>Search</Link>
```

:::

## Scroll preservation

You can use the `preserveScroll` prop to prevent Inertia from automatically resetting the scroll position when making a page visit.

:::tabs key:frameworks
== Vue 2

```vue
import { Link } from '@inertiajs/vue2'

<Link href="/" preserve-scroll>Home</Link>
```

== Vue 3

```vue
import { Link } from '@inertiajs/vue3'

<Link href="/" preserve-scroll>Home</Link>
```

== React

```jsx
import { Link } from '@inertiajs/react'

<Link href="/" preserveScroll>
  Home
</Link>
```

== Svelte

```svelte
import { inertia, Link } from '@inertiajs/svelte'

<a href="/" use:inertia="{{ preserveScroll: true }}">Home</a>

<Link href="/" preserveScroll>Home</Link>
```

:::

For more information on managing scroll position, please consult the documentation on [scroll management](/guide/scroll-management).

## Partial reloads

The `only` prop allows you to specify that only a subset of a page's props (data) should be retrieved from the server on subsequent visits to that page.

:::tabs key:frameworks
== Vue 2

```vue
import { Link } from '@inertiajs/vue2'

<Link href="/users?active=true" :only="['users']">Show active</Link>
```

== Vue 3

```vue
import { Link } from '@inertiajs/vue3'

<Link href="/users?active=true" :only="['users']">Show active</Link>
```

== React

```jsx
import { Link } from '@inertiajs/react'

<Link href="/users?active=true" only={['users']}>
  Show active
</Link>
```

== Svelte

```svelte
import { inertia, Link } from '@inertiajs/svelte'

<a href="/users?active=true" use:inertia="{{ only: ['users'] }}">Show active</a>

<Link href="/users?active=true" only={['users']}>Show active</Link>
```

:::

For more information on this topic, please consult the complete documentation on [partial reloads](/guide/partial-reloads.md).

## Active states

It's often desirable to set an active state for navigation links based on the current page. This can be accomplished when using Inertia by inspecting the `page` object and doing string comparisons against the `page.url` and `page.component` properties.

:::tabs key:frameworks
== Vue 2

```vue
import { Link } from '@inertiajs/vue2'

// URL exact match...
<Link href="/users" :class="{ active: $page.url === '/users' }">Users</Link>

// Component exact match...
<Link
  href="/users"
  :class="{ active: $page.component === 'Users/Index' }"
>Users</Link>

// URL starts with (/users, /users/create, /users/1, etc.)...
<Link
  href="/users"
  :class="{ active: $page.url.startsWith('/users') }"
>Users</Link>

// Component starts with (Users/Index, Users/Create, Users/Show, etc.)...
<Link
  href="/users"
  :class="{ active: $page.component.startsWith('Users') }"
>Users</Link>
```

== Vue 3

```vue
import { Link } from '@inertiajs/vue3'

// URL exact match...
<Link href="/users" :class="{ active: $page.url === '/users' }">Users</Link>

// Component exact match...
<Link
  href="/users"
  :class="{ active: $page.component === 'Users/Index' }"
>Users</Link>

// URL starts with (/users, /users/create, /users/1, etc.)...
<Link
  href="/users"
  :class="{ active: $page.url.startsWith('/users') }"
>Users</Link>

// Component starts with (Users/Index, Users/Create, Users/Show, etc.)...
<Link
  href="/users"
  :class="{ active: $page.component.startsWith('Users') }"
>Users</Link>
```

== React

```jsx
import { usePage } from '@inertiajs/react'

const { url, component } = usePage()

// URL exact match...
<Link href="/users" className={url === '/users' ? 'active' : ''}>Users</Link>

// Component exact match...
<Link href="/users" className={component === 'Users/Index' ? 'active' : ''}>Users</Link>

// URL starts with (/users, /users/create, /users/1, etc.)...
<Link href="/users" className={url.startsWith('/users') ? 'active' : ''}>Users</Link>

// Component starts with (Users/Index, Users/Create, Users/Show, etc.)...
<Link href="/users" className={component.startsWith('Users') ? 'active' : ''}>Users</Link>
```

== Svelte

```svelte
import { page } from '@inertiajs/svelte'

// URL exact match...
<Link href="/users" class={$page.url === '/users' ? 'active' : ''}>Users</Link>

// Component exact match...
<Link href="/users" class={$page.component === 'Users/Index' ? 'active' : ''}>Users</Link>

// URL starts with (/users, /users/create, /users/1, etc.)...
<Link href="/users" class={$page.url.startsWith('/users') ? 'active' : ''}>Users</Link>

// Component starts with (Users/Index, Users/Create, Users/Show, etc.)...
<Link href="/users" class={$page.component.startsWith('Users') ? 'active' : ''}>Users</Link>
```

:::

You can perform exact match comparisons (`===`), `startsWith()` comparisons (useful for matching a subset of pages), or even more complex comparisons using regular expressions.

Using this approach, you're not limited to just setting class names. You can use this technique to conditionally render any markup on active state, such as different link text or even an SVG icon that represents the link is active.
