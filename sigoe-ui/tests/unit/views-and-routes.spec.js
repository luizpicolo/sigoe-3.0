import { describe, expect, it } from 'vitest'
import router from '@/router'

const viewModules = import.meta.glob('../../src/views/**/*.vue', { eager: true })

describe('Views', () => {
  it.each(Object.entries(viewModules))('discovers %s', ([, module]) => {
    expect(module).toBeDefined()
  })
})

describe('Application router', () => {
  it('is created and exposes routes', () => {
    expect(router).toBeDefined()
    expect(Array.isArray(router.getRoutes())).toBe(true)
    expect(router.getRoutes().length).toBeGreaterThan(0)
  })

  it.each(router.getRoutes())('defines a valid route: $path', (route) => {
    expect(typeof route.path).toBe('string')
    expect(route.path.length).toBeGreaterThan(0)
    expect(route.components || route.component || route.redirect).toBeDefined()
  })
})
