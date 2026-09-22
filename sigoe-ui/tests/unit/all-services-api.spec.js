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

const contracts = [
  ['authentication', authentication, ['isTokenValid', 'logout']],
  ['courses', courses, ['list', 'find', 'create', 'update', 'remove', 'options']],
  ['dashboard', dashboard, ['statistics']],
  ['incidents', incidents, ['list', 'find', 'create', 'update', 'remove', 'options']],
  ['permissions', permissions, ['can', 'loadCurrentPermissions', 'clearPermissions', 'getUserPermissions', 'saveUserPermissions']],
  ['reports', reports, ['list', 'export']],
  ['school_groups', schoolGroups, ['list', 'find', 'create', 'update', 'remove', 'options']],
  ['students', students, ['list', 'find', 'create', 'update', 'remove', 'options']],
  ['users', users, ['list', 'find', 'create', 'update', 'remove', 'options']],
]

describe('contratos de todos os services', () => {
  it.each(contracts)('mantém a API pública de %s', (_, module, exports) => {
    for (const exportName of exports) {
      expect(module, `${exportName} ausente`).toHaveProperty(exportName)
      expect(typeof module[exportName]).toBe('function')
    }
  })
})
