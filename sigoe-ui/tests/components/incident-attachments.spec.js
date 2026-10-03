import { mount, flushPromises } from '@vue/test-utils'
import { describe, expect, it, vi, beforeEach } from 'vitest'
import IncidentAttachments from '@/components/incidents/incident-attachments.vue'
import { uploadAttachment, removeAttachment, downloadAttachment } from '@/services/incidents'
import { confirm, success } from '@/utils/sweetPopup2'

vi.mock('@/services/incidents', () => ({
  uploadAttachment: vi.fn(),
  removeAttachment: vi.fn(),
  downloadAttachment: vi.fn()
}))

vi.mock('@/services/permissions', () => ({ can: vi.fn(() => true) }))

vi.mock('@/utils/sweetPopup2', () => ({
  error: vi.fn(),
  success: vi.fn(),
  confirm: vi.fn()
}))

const mountComponent = props => mount(IncidentAttachments, {
  props: {
    incidentId: 1,
    attachments: [],
    canUpload: true,
    canDelete: true,
    ...props
  },
  global: {
    stubs: {
      Card: { template: '<div><slot /></div>' },
      Button: { template: '<button :disabled="disabled" @click="$emit(\'click\')"><slot /></button>', props: ['disabled'], emits: ['click'] }
    }
  }
})

describe('incident attachments component', () => {
  beforeEach(() => vi.clearAllMocks())

  it('envia um PDF selecionado e informa o componente pai', async () => {
    const wrapper = mountComponent()
    const file = new File(['pdf'], 'evidencia.pdf', { type: 'application/pdf' })
    uploadAttachment.mockResolvedValue({ attachment: { id: 10, filename: 'evidencia.pdf', url: '/uploads/evidencia.pdf' } })

    const input = wrapper.find('input[type="file"]')
    Object.defineProperty(input.element, 'files', { value: [file] })
    await input.trigger('change')

    expect(uploadAttachment).toHaveBeenCalledWith(1, file)
    expect(wrapper.emitted('uploaded')[0]).toEqual([{ id: 10, filename: 'evidencia.pdf', url: '/uploads/evidencia.pdf' }])
    expect(success).toHaveBeenCalledWith('PDF anexado com sucesso.')
  })

  it('baixa o PDF por uma requisição autenticada', async () => {
    const blob = new Blob(['pdf'], { type: 'application/pdf' })
    downloadAttachment.mockResolvedValue(blob)
    URL.createObjectURL = vi.fn(() => 'blob:test')
    URL.revokeObjectURL = vi.fn()
    vi.spyOn(HTMLAnchorElement.prototype, 'click').mockImplementation(() => {})
    const wrapper = mountComponent({ attachments: [{ id: 10, filename: 'evidencia.pdf' }] })
    await wrapper.findAll('button').find(button => button.text().includes('evidencia.pdf')).trigger('click')
    await flushPromises()
    expect(downloadAttachment).toHaveBeenCalledWith(1, 10)
    expect(URL.createObjectURL).toHaveBeenCalledWith(blob)
    expect(wrapper.find('a[href*="uploads"]').exists()).toBe(false)
  })

  it('permite excluir um PDF listado', async () => {
    const wrapper = mountComponent({
      attachments: [{ id: 10, filename: 'evidencia.pdf', url: '/uploads/evidencia.pdf' }]
    })
    confirm.mockResolvedValue(true)
    removeAttachment.mockResolvedValue(undefined)

    await wrapper.findAll('button').find(button => button.text().includes('Excluir')).trigger('click')
    await flushPromises()

    expect(removeAttachment).toHaveBeenCalledWith(1, 10)
    expect(wrapper.emitted('deleted')).toEqual([[10]])
    expect(success).toHaveBeenCalledWith('PDF excluído com sucesso.')
  })
})
