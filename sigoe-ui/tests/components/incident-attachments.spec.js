import { mount } from '@vue/test-utils'
import { describe, expect, it, vi, beforeEach } from 'vitest'
import IncidentAttachments from '@/components/incidents/incident-attachments.vue'
import { uploadAttachment, removeAttachment } from '@/services/incidents'
import { confirm, success } from '@/utils/sweetPopup2'

vi.mock('@/services/incidents', () => ({
  uploadAttachment: vi.fn(),
  removeAttachment: vi.fn()
}))

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
      Button: { template: '<button :disabled="disabled" @click="$emit(\'click\')"><slot /></button>', props: ['disabled'] }
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

  it('permite excluir um PDF listado', async () => {
    const wrapper = mountComponent({
      attachments: [{ id: 10, filename: 'evidencia.pdf', url: '/uploads/evidencia.pdf' }]
    })
    confirm.mockResolvedValue(true)
    removeAttachment.mockResolvedValue(undefined)

    await wrapper.findAll('button')[1].trigger('click')

    expect(removeAttachment).toHaveBeenCalledWith(1, 10)
    expect(wrapper.emitted('deleted')).toEqual([[10]])
    expect(success).toHaveBeenCalledWith('PDF excluído com sucesso.')
  })
})
