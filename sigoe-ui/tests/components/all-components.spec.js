import { describe, expect, it } from 'vitest'

const componentModules = import.meta.glob('../../src/components/**/*.vue', { eager: true })

describe('Vue components', () => {
  it.each(Object.entries(componentModules))('discovers %s', ([, module]) => {
    expect(module).toBeDefined()
  })
})
