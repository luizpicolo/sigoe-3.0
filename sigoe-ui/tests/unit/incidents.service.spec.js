import axios from 'axios'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { list } from '@/services/incidents'

vi.mock('axios', () => ({ default: { get: vi.fn() } }))

describe('incidents service', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    localStorage.setItem('jwt', 'token')
  })

  it('lista ocorrências com os parâmetros informados', async () => {
    axios.get.mockResolvedValue({ data: { incidents: [{ id: 1 }], total: 1 } })

    await expect(list(2, 'date_incident', 'aluno', 25)).resolves.toEqual({ incidents: [{ id: 1 }], total: 1 })
    expect(axios.get).toHaveBeenCalledWith(expect.stringContaining('/api/incidents'), expect.objectContaining({ params: { page: 2, order: 'date_incident', search: 'aluno', amount: 25 } }))
  })
})
