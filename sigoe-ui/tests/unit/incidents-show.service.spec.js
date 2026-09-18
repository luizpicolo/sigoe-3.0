import axios from 'axios'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { find } from '@/services/incidents'

vi.mock('axios', () => ({ default: { get: vi.fn() } }))

describe('incidents show service', () => {
  beforeEach(() => vi.clearAllMocks())

  it('busca uma ocorrência por id', async () => {
    axios.get.mockResolvedValue({ data: { incident: { id: 1 } } })

    await expect(find(1)).resolves.toEqual({ incident: { id: 1 } })
    expect(axios.get).toHaveBeenCalledWith(expect.stringContaining('/api/incidents/1'), expect.any(Object))
  })
})
