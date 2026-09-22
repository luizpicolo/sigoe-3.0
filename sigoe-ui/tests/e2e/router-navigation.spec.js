import { describe, expect, it, beforeEach } from 'vitest'
import { createRouter, createMemoryHistory } from 'vue-router'

const routeModules = import.meta.glob('../../src/views/**/*.vue', { eager: true })

function createTestRouter() {
  const routes = Object.entries(routeModules).map(([path, module], index) => ({
    path: `/test-view-${index}`,
    name: `test-view-${index}`,
    component: module.default,
    meta: { source: path },
  }))

  return createRouter({
    history: createMemoryHistory(),
    routes,
  })
}

describe('E2E-style view navigation integration', () => {
  let testRouter

  beforeEach(() => {
    testRouter = createTestRouter()
  })

  it('registers every view as a navigable route', () => {
    expect(testRouter.getRoutes().length).toBe(Object.keys(routeModules).length)
  })

  it.each(Object.keys(routeModules))('navigates to the route generated for %s', async (_, index) => {
    const route = testRouter.getRoutes()[index]
    await testRouter.push(route.path)
    await testRouter.isReady()

    expect(testRouter.currentRoute.value.name).toBe(route.name)
    expect(testRouter.currentRoute.value.meta.source).toBeDefined()
  })
})
