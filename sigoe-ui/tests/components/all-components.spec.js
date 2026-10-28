import { describe, expect, it } from 'vitest'
import { shallowMount } from '@vue/test-utils'
import { createMemoryHistory, createRouter, routerKey } from 'vue-router'

const componentModules = import.meta.glob('../../src/components/**/*.vue', { eager: true })

const globalOptions = {
  stubs: {
    RouterLink: true,
    RouterView: true,
    FontAwesomeIcon: true,
  },
}

const router = createRouter({ history: createMemoryHistory(), routes: [] })

const propsFor = path => ({
  incident: {},
  incidentId: 1,
  stateUser: { user: {} },
  ...(path.endsWith('/breadcrumb.vue') ? { items: [] } : {}),
  ...(path.endsWith('/header.vue') ? {} : {}),
  ...(path.endsWith('/academic-export-form.vue') ? { action: '/export' } : {}),
  ...(path.endsWith('/sidebar.vue') ? { activePage: '' } : {}),
  ...(path.endsWith('/ui/alert.vue') ? { message: '' } : {}),
  ...(path.endsWith('/ui/chart.vue') ? { title: '' } : {})
})

describe('Componentes Vue', () => {
  it.each(Object.entries(componentModules))('exporta o componente %s', (_, module) => {
    expect(module?.default).toBeDefined()
  })

  it.each(Object.entries(componentModules))('monta o componente %s', (path, module) => {
    const component = module?.default
    expect(component).toBeDefined()

    const wrapper = shallowMount(component, {
      global: { ...globalOptions, provide: { [routerKey]: router } },
      props: propsFor(path),
    })

    expect(wrapper.exists()).toBe(true)
    wrapper.unmount()
  })
})
