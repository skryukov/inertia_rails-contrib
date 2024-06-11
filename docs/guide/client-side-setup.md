# Client-side setup

Once you have your [server-side framework configured](/guide/server-side-setup.md), you then need to setup your client-side framework. Inertia currently provides support for React, Vue, and Svelte.

> [!NOTE]
> See [Rails generator](/guide/server-side-setup#rails-generator) for a quick way to setup Inertia in your Rails application.

## Install dependencies

First, install the Inertia client-side adapter corresponding to your framework of choice.

:::tabs key:frameworks
== Vue 2

```shell
npm install @inertiajs/vue2
```

== Vue 3

```shell
npm install @inertiajs/vue3
```

== React

```shell
npm install @inertiajs/react
```

== Svelte

```shell
npm install @inertiajs/svelte
```

:::

## Initialize the Inertia app

Next, update your main JavaScript file to boot your Inertia app. To accomplish this, we'll initialize the client-side framework with the base Inertia component.

:::tabs key:frameworks
== Vue 2

```js
import Vue from 'vue'
import { createInertiaApp } from '@inertiajs/vue2'

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob('./pages/**/*.vue', { eager: true })
    return pages[`./pages/${name}.vue`]
  },
  setup({ el, App, props, plugin }) {
    Vue.use(plugin)

    new Vue({
      render: (h) => h(App, props),
    }).$mount(el)
  },
})
```

== Vue 3

```js
import { createApp, h } from 'vue'
import { createInertiaApp } from '@inertiajs/vue3'

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob('./pages/**/*.vue', { eager: true })
    return pages[`./pages/${name}.vue`]
  },
  setup({ el, App, props, plugin }) {
    createApp({ render: () => h(App, props) })
      .use(plugin)
      .mount(el)
  },
})
```

== React

```js
import { createInertiaApp } from '@inertiajs/react'
import { createElement } from 'react'
import { createRoot } from 'react-dom/client'

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob('./pages/**/*.jsx', { eager: true })
    return pages[`./pages/${name}.jsx`]
  },
  setup({ el, App, props }) {
    const root = createRoot(el)
    root.render(createElement(App, props))
  },
})
```

== Svelte

```js
import { createInertiaApp } from '@inertiajs/svelte'

createInertiaApp({
  resolve: (name) => {
    const pages = import.meta.glob('./pages/**/*.svelte', { eager: true })
    return pages[`./pages/${name}.svelte`]
  },
  setup({ el, App, props }) {
    new App({ target: el, props })
  },
})
```

:::

The `setup` callback receives everything necessary to initialize the client-side framework, including the root Inertia `App` component.

# Resolving components

The `resolve` callback tells Inertia how to load a page component. It receives a page name (string), and returns a page component module. How you implement this callback depends on which bundler (Vite or Webpack) you're using.

:::tabs key:frameworks
== Vue 2

```js
// Vite
resolve: name => {
  const pages = import.meta.glob('./pages/**/*.vue', { eager: true })
  return pages[`./pages/${name}.vue`]
},

// Webpacker/Shakapacker
resolve: name => require(`./pages/${name}`),
```

== Vue 3

```js
// Vite
resolve: name => {
  const pages = import.meta.glob('./pages/**/*.vue', { eager: true })
  return pages[`./pages/${name}.vue`]
},

// Webpacker/Shakapacker
resolve: name => require(`./pages/${name}`),
```

== React

```js
// Vite
resolve: name => {
  const pages = import.meta.glob('./pages/**/*.jsx', { eager: true })
  return pages[`./pages/${name}.jsx`]
},

// Webpacker/Shakapacker
resolve: name => require(`./pages/${name}`),
```

== Svelte

```js
// Vite
resolve: name => {
  const pages = import.meta.glob('./pages/**/*.svelte', { eager: true })
  return pages[`./pages/${name}.svelte`]
},

// Webpacker/Shakapacker
resolve: name => require(`./pages/${name}.svelte`),
```

:::

By default we recommend eager loading your components, which will result in a single JavaScript bundle. However, if you'd like to lazy-load your components, see our [code splitting](/guide/code-splitting.md) documentation.

## Defining a root element

By default, Inertia assumes that your application's root template has a root element with an `id` of `app`. If your application's root element has a different `id`, you can provide it using the `id` property.

```js
createInertiaApp({
  id: 'my-app',
  // ...
})
```
