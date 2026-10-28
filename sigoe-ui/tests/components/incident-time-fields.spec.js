import { mount, flushPromises } from '@vue/test-utils'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import IncidentForm from '@/views/incidents/form.vue'
import MobileIncidentForm from '@/views/mobile/incidents/Form.vue'
import { find, options, update } from '@/services/incidents'

const mocks = vi.hoisted(() => ({
  route: { params: { id: '42' } },
  router: { push: vi.fn(), back: vi.fn() }
}))

vi.mock('vue-router', () => ({
  useRoute: () => mocks.route,
  useRouter: () => mocks.router
}))

vi.mock('@/services/incidents', () => ({
  create: vi.fn(),
  find: vi.fn(),
  options: vi.fn(),
  update: vi.fn()
}))

vi.mock('@/services/permissions', () => ({ can: vi.fn(() => true) }))
vi.mock('@/utils/sweetPopup2', () => ({
  error: vi.fn(),
  success: vi.fn(() => true)
}))

const incidentOptions = {
  assistants: [],
  sectors: [],
  type_incidents: [],
  student_duties: [],
  prohibition_and_responsibilities: [],
  sanctions: []
}

const incident = {
  id: 42,
  time_incident: '2000-01-01T20:20:00.000-04:00',
  date_incident: '2026-10-01',
  type_student: 'resident',
  assistant_id: 7,
  type_incident_id: 3,
  description: 'Descrição',
  student: { name: 'Estudante' }
}

const stubs = {
  Header: true,
  Sidebar: true,
  Breadcrumb: true,
  Card: { template: '<section><slot /></section>' },
  Select: {
    props: ['options', 'modelValue'],
    template: '<div />'
  },
  Button: { template: '<button><slot /></button>' },
  StudentSearchableSelect: true,
  MobileLayout: { template: '<main><slot /></main>' }
}

describe('campo de horário da ocorrência', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    mocks.route.params.id = '42'
    options.mockResolvedValue(incidentOptions)
    find.mockResolvedValue({ incident })
    update.mockResolvedValue({ error: null })
  })

  it.each([
    ['web', IncidentForm],
    ['mobile', MobileIncidentForm]
  ])('carrega e salva 20:20 sem deslocamento no formulário %s', async (_surface, component) => {
    const wrapper = mount(component, { global: { stubs } })
    await flushPromises()

    const timeInput = wrapper.find('input[type="time"]')
    expect(timeInput.element.value).toBe('20:20')

    await wrapper.find('form').trigger('submit')
    await flushPromises()

    expect(update).toHaveBeenCalledWith('42', expect.objectContaining({ time_incident: '20:20' }))
  })
})
