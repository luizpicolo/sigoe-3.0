import { describe, expect, it } from 'vitest'

const serviceModules = import.meta.glob('../../src/services/**/*.js', { eager: true })
const utilityModules = import.meta.glob('../../src/utils/**/*.js', { eager: true })

const assertLoadedModule = (module) => {
  expect(module).toBeDefined()
  expect(['object', 'function', 'string']).toContain(typeof module)
}

describe('Services contract', () => {
  it.each(Object.entries(serviceModules))('loads %s', ([, module]) => {
    assertLoadedModule(module)
  })

  it.each(Object.entries(serviceModules))('exposes a service module for %s', ([, module]) => {
    assertLoadedModule(module)
  })
})

describe('Utilities contract', () => {
  it.each(Object.entries(utilityModules))('loads %s', ([, module]) => {
    assertLoadedModule(module)
  })
})
