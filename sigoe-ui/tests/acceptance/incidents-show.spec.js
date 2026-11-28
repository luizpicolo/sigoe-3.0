import { flushPromises, mount } from '@vue/test-utils'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import IncidentShow from '@/views/incidents/show.vue'

const mocks = vi.hoisted(() => ({
  find: vi.fn(),
  sendWhatsapp: vi.fn(),
  route: { params: { id: '42' } },
  router: { push: vi.fn() }
}))

vi.mock('vue-router', () => ({
  useRoute: () => mocks.route,
  useRouter: () => mocks.router
}))

vi.mock('@/services/incidents', () => ({
  find: mocks.find,
  remove: vi.fn(),
  sendWhatsapp: mocks.sendWhatsapp
}))

vi.mock('@/services/permissions', () => ({ can: vi.fn(() => true) }))
vi.mock('@/utils/sweetPopup2', () => ({
  error: vi.fn(),
  success: vi.fn(),
  confirm: vi.fn()
}))
vi.mock('@/services/reports/incidents', () => ({ generateIncidentReportFromIncident: vi.fn() }))

const stubs = {
  Header: true,
  Sidebar: true,
  Breadcrumb: true,
  Button: {
    props: ['disabled', 'to'],
    emits: ['click'],
    template: '<button :disabled="disabled" @click="$emit(\'click\')"><slot /></button>'
  },
  IncidentAttachments: true,
  AcademicExportForm: true,
  Card: {
    props: ['title'],
    template: '<section><h2>{{ title }}</h2><slot /></section>'
  }
}

describe('aceitação: visualização de ocorrência', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    mocks.route.params.id = '42'
  })

  it('carrega a view de detalhes da ocorrência', () => {
    expect(IncidentShow).toBeDefined()
  })

  it.each([
    ['yes_', 'Sim', 'Verificada'],
    ['no_', 'Não', 'Pendente'],
    [null, 'Não', 'Pendente']
  ])('mostra o estado correto para is_resolved=%s', async (isResolved, expectedResolution, expectedVerification) => {
    mocks.find.mockResolvedValue({
      incident: {
        id: 42,
        student: { contact: '5567999990000' },
        is_resolved: isResolved,
        student: {},
        course: {},
        student_duties: [],
        prohibition_and_responsibilities: [],
        attachments: []
      }
    })
    const wrapper = mount(IncidentShow, { global: { stubs } })

    await flushPromises()

    const resolvedLabel = wrapper.findAll('dt').find(label => label.text() === 'Ocorrência resolvida')
    const verificationLabel = wrapper.findAll('dt').find(label => label.text() === 'Verificada')
    expect(resolvedLabel.element.nextElementSibling.textContent.trim()).toBe(expectedResolution)
    expect(verificationLabel.element.nextElementSibling.textContent.trim()).toBe(expectedVerification)
  })

  it('envia manualmente ao responsável com permissão e desabilita após o envio', async () => {
    const { can } = await import('@/services/permissions')
    can.mockReturnValue(true)
    mocks.sendWhatsapp.mockResolvedValue({ message: 'enviado' })
    mocks.find.mockResolvedValue({ incident: {
      id: 42,
      student: { contact: '5567999990000' },
      course: {},
      student_duties: [],
      prohibition_and_responsibilities: [],
      attachments: []
    } })
    const wrapper = mount(IncidentShow, { global: { stubs } })
    await flushPromises()

    const sendButton = wrapper.findAll('button').find(button => button.text().includes('Enviar ao responsável'))
    expect(sendButton.attributes('disabled')).toBeUndefined()
    await sendButton.trigger('click')
    await flushPromises()

    expect(mocks.sendWhatsapp).toHaveBeenCalledWith('42')
    expect(wrapper.findAll('button').find(button => button.text().includes('Enviado ao responsável')).exists()).toBe(true)
  })

  it('não habilita envio sem contato do responsável', async () => {
    mocks.find.mockResolvedValue({ incident: {
      id: 42,
      student: { contact: null },
      course: {},
      student_duties: [],
      prohibition_and_responsibilities: [],
      attachments: []
    } })
    const wrapper = mount(IncidentShow, { global: { stubs } })
    await flushPromises()

    const sendButton = wrapper.findAll('button').find(button => button.text().includes('Enviar ao responsável'))
    expect(sendButton.attributes('disabled')).toBeDefined()
  })
})
