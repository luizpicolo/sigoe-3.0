import { describe, expect, it } from 'vitest'
import { shallowMount } from '@vue/test-utils'

const componentModules = import.meta.glob('../../src/components/**/*.vue', { eager: true })

const globalOptions = {
  stubs: {
    RouterLink: true,
    RouterView: true,
    FontAwesomeIcon: true,
  },
}

describe('Componentes Vue', () => {
  it.each(Object.entries(componentModules))('exporta o componente %s', (_, module) => {
    expect(module?.default).toBeDefined()
  })

  it.each(Object.entries(componentModules))('monta o componente %s', (path, module) => {
    const component = module?.default
    expect(component).toBeDefined()

    const wrapper = shallowMount(component, {
      global: globalOptions,
      props: { incident: {}, incidentId: 1, stateUser: { user: {} } },
    })

    expect(wrapper.exists()).toBe(true)
    wrapper.unmount()
  })
})
