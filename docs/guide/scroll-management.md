# Scroll management

## Scroll resetting

When navigating between pages, Inertia mimics default browser behaviour by automatically resetting the scroll position of the document body (as well as any [scroll regions](#scroll-regions) you've defined) back to the top. In addition, Inertia keeps track of the scroll position of each page and automatically restores that scroll position as you navigate forward and back in history.

## Scroll preservation

Sometimes it's desirable to prevent the default scroll resetting behavior when making visits. You can disable this behaviour using the `preserveScroll` option when [manually making visits](/guide/manual-visits.md).

```js
router.visit(url, { preserveScroll: true })
```

You can also lazily evaluate the `preserveScroll` option based on the server's response by providing a callback to the option.

```js
router.post('/users', data, {
  preserveScroll: (page) => Object.keys(page.props.errors).length,
})
```

You can also preserve the scroll position when using [Inertia links](/guide/links.md) using the `preserve-scroll` attribute.

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
;<Link href="/" preserveScroll>
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

## Scroll regions

If your app doesn't use document body scrolling, but instead has scrollable elements (using the overflow CSS property), scroll resetting will not work. In these situations, you must tell Inertia which scrollable elements to manage by adding a scroll-region attribute to the element.

```html
<div class="overflow-y-auto" scroll-region>
  <!-- Your page content -->
</div>
```
