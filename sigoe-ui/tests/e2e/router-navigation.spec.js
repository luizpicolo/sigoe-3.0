import { beforeEach, describe, expect, it } from 'vitest'
import { createMemoryHistory, createRouter } from 'vue-router'

const routeModules = import.meta.glob('../../src/views/**/*.vue', { eager: true })
const viewCases = Object.entries(routeModules).map(([path], index) => ({ path, index }))

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
    expect(testRouter.getRoutes().length).toBe(viewCases.length)
  })

  it.each(viewCases)('navigates to the route generated for $path', async ({ index }) => {
    const route = testRouter.getRoutes()[index]
    await testRouter.push(route.path)
    await testRouter.isReady()

    expect(testRouter.currentRoute.value.name).toBe(route.name)
    expect(testRouter.currentRoute.value.meta.source).toBeDefined()
  })
})
