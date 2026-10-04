import { describe, expect, it } from 'vitest'

const views = import.meta.glob('../../src/views/**/*.vue', { eager: true })

const expectedViews = [
  'courses/form.vue', 'courses/list.vue', 'forbidden.vue', 'home.vue', 'login.vue',
  'incidents/form.vue', 'incidents/list.vue', 'incidents/report.vue', 'incidents/show.vue',
  'school_groups/form.vue', 'school_groups/list.vue',
  'students/form.vue', 'students/list.vue', 'students/show.vue',
  'users/change-password.vue', 'users/form.vue', 'users/list.vue', 'users/permissions.vue', 'users/show.vue',
]

describe('inventário de views', () => {
  it('inclui todas as views funcionais esperadas', () => {
    const paths = Object.keys(views)
    for (const view of expectedViews) {
      expect(paths.some(path => path.endsWith(`/views/${view}`)), `view ausente: ${view}`).toBe(true)
    }
  })

  it.each(Object.entries(views))('compila a view %s', (_, module) => {
    expect(module.default).toBeDefined()
  })
})
