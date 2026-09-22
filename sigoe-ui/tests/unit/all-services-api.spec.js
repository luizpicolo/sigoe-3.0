import { describe, expect, it } from 'vitest'
import * as authentication from '@/services/authentication'
import * as courses from '@/services/courses'
import * as dashboard from '@/services/dashboard'
import * as incidents from '@/services/incidents'
import * as permissions from '@/services/permissions'
import * as reports from '@/services/reports/incidents'
import * as schoolGroups from '@/services/school_groups'
import * as students from '@/services/students'
import * as users from '@/services/users'

const modules = [
  ['authentication', authentication],
  ['courses', courses],
  ['dashboard', dashboard],
  ['incidents', incidents],
  ['permissions', permissions],
  ['reports', reports],
  ['school_groups', schoolGroups],
  ['students', students],
  ['users', users],
]

describe('contratos de todos os services', () => {
  it.each(modules)('carrega e expõe funções públicas em %s', (_, module) => {
    const entries = Object.entries(module)
    expect(entries.length).toBeGreaterThan(0)
    expect(entries.some(([, value]) => typeof value === 'function')).toBe(true)
  })

  it.each(modules)('não possui exports indefinidos em %s', (_, module) => {
    for (const [name, value] of Object.entries(module)) {
      expect(value, `export ${name} inválido`).not.toBeUndefined()
    }
  })
})
