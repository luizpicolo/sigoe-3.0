import { describe, expect, it } from 'vitest'

const serviceModules = import.meta.glob('../../src/services/**/*.js', { eager: true })
const utilityModules = import.meta.glob('../../src/utils/**/*.js', { eager: true })

describe('Services contract', () => {
  it.each(Object.entries(serviceModules))('loads %s and exposes a module', ([, module]) => {
    expect(module).toBeDefined()
    expect(typeof module).toBe('object')
  })

  it.each(Object.entries(serviceModules))('exports callable or data members from %s', ([, module]) => {
    const exports = Object.values(module)
    expect(exports.length).toBeGreaterThan(0)
    expect(exports.some((value) => typeof value === 'function' || value !== undefined)).toBe(true)
  })
})

describe('Utilities contract', () => {
  it.each(Object.entries(utilityModules))('loads %s', ([, module]) => {
    expect(module).toBeDefined()
    expect(Object.keys(module).length).toBeGreaterThan(0)
  })
})
