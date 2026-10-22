import { flushPromises, mount } from '@vue/test-utils'
import { describe, expect, it, vi, beforeEach } from 'vitest'
import IncidentList from '@/views/incidents/list.vue'

const { listMock } = vi.hoisted(() => ({ listMock: vi.fn() }))

vi.mock('@/services/incidents', () => ({ list: listMock }))
vi.mock('@/services/permissions', () => ({
  can: vi.fn(() => true),
  permissionState: { user: { super_admin: false }, permissions: {}, admin: false },
}))

vi.mock('vue-router', () => ({ useRouter: () => ({ push: vi.fn() }) }))

describe('aceitação: listagem de ocorrências', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    listMock.mockResolvedValue({ incidents: [{ id: 1, date_incident: '2025-04-30', student: { name: 'Luiz' }, course: { name: 'Informática' }, visibility: 'public', is_resolved: 'no_', signed_in: '2025-04-30' }], total: 1 })
  })

  it('carrega e apresenta as ocorrências da API', async () => {
    const wrapper = mount(IncidentList, { global: { stubs: { Sidebar: true, Breadcrumb: true, RouterLink: true, Input: { props: ['modelValue'], emits: ['update:modelValue'], template: '<input />' }, Button: { template: '<button><slot /></button>' }, VPagination: true } } })

    await flushPromises()

    expect(listMock).toHaveBeenCalledWith(1, 'id', '', 10)
    expect(wrapper.text()).toContain('Luiz')
    expect(wrapper.text()).toContain('Informática')
    expect(wrapper.text()).toContain('30/04/2025')
    const resolvedCell = wrapper.find('tbody tr').findAll('td')[5]
    expect(resolvedCell.find('i.fa-xmark').exists()).toBe(true)
    expect(resolvedCell.find('i.fa-check').exists()).toBe(false)
  })

  it.each([
    ['yes_', 'fa-check'],
    [null, 'fa-xmark']
  ])('mostra o estado correto quando is_resolved é %s', async (isResolved, expectedIcon) => {
    listMock.mockResolvedValue({
      incidents: [{ id: 1, date_incident: '2025-04-30', visibility: 'public', is_resolved: isResolved }],
      total: 1
    })
    const wrapper = mount(IncidentList, { global: { stubs: { Sidebar: true, Breadcrumb: true, RouterLink: true, Button: { template: '<button><slot /></button>' }, VPagination: true } } })

    await flushPromises()

    const resolvedCell = wrapper.find('tbody tr').findAll('td')[5]
    expect(resolvedCell.find(`i.${expectedIcon}`).exists()).toBe(true)
  })
})
