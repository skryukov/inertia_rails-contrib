import { createInertiaApp } from '@inertiajs/svelte'
import type { ComponentType } from 'svelte';

type ResolvedComponent = { default: ComponentType, layout?: ComponentType }

createInertiaApp({
  // Set default page title
  // see https://inertia-rails.netlify.app/guide/title-and-meta
  //
  // title: title => title ? `${title} - App` : 'App',

  // Disable progress bar
  //
  // see https://inertia-rails.netlify.app/guide/progress-indicators
  // progress: false,

  resolve: (name) => {
    const pages = import.meta.glob('../pages/**/*.svelte', { eager: true })
    return pages[`../pages/${name}.svelte`] as ResolvedComponent

    // To use a default layout, import the Layout component
    // and use the following lines.
    // see https://inertia-rails.netlify.app/guide/pages#default-layouts
    //
    // const page = pages[`../pages/${name}.svelte`] as ResolvedComponent
    // return { default: page.default, layout: page.layout || Layout }
  },

  setup({ el, App }) {
    new App({ target: el })
  },
})
