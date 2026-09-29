import axios from 'axios'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { find, uploadAttachment, removeAttachment } from '@/services/incidents'

vi.mock('axios', () => ({ default: { get: vi.fn(), post: vi.fn(), delete: vi.fn() } }))

describe('incidents show service', () => {
  beforeEach(() => vi.clearAllMocks())

  it('busca uma ocorrência por id', async () => {
    axios.get.mockResolvedValue({ data: { incident: { id: 1 } } })

    await expect(find(1)).resolves.toEqual({ incident: { id: 1 } })
    expect(axios.get).toHaveBeenCalledWith(expect.stringContaining('/api/incidents/1'), expect.any(Object))
  })

  it('envia um PDF para uma ocorrência', async () => {
    const file = new File(['pdf'], 'evidencia.pdf', { type: 'application/pdf' })
    axios.post.mockResolvedValue({ data: { attachment: { id: 2, filename: 'evidencia.pdf' } } })

    await expect(uploadAttachment(1, file)).resolves.toEqual({ attachment: { id: 2, filename: 'evidencia.pdf' } })
    expect(axios.post).toHaveBeenCalledWith(expect.stringContaining('/api/incidents/1/attachments'), expect.any(FormData), expect.any(Object))
  })

  it('remove um PDF da ocorrência', async () => {
    axios.delete.mockResolvedValue({})

    await expect(removeAttachment(1, 2)).resolves.toBeUndefined()
    expect(axios.delete).toHaveBeenCalledWith(expect.stringContaining('/api/incidents/1/attachments/2'), expect.any(Object))
  })
})
