import axios from 'axios'

import { describe, expect, it, vi, beforeEach } from 'vitest'

import { find, update, remove } from '@/services/users'

vi.mock('axios', () => ({
  default: {
    get: vi.fn(),
    put: vi.fn(),
    delete: vi.fn()
  }
}))

describe('users service', () => {
  beforeEach(() => vi.clearAllMocks())

  it('busca usuário por id', async () => {
    axios.get.mockResolvedValue({
      data: {
        user: {
          id: 7,
          name: 'Luiz'
        }
      }
    })

    await expect(find(7)).resolves.toEqual({
      user: {
        id: 7,
        name: 'Luiz'
      }
    })

    expect(axios.get).toHaveBeenCalledWith(
      expect.stringContaining('/api/users/7'),
      expect.any(Object)
    )
  })

  it('atualiza usuário enviando o envelope user', async () => {
    axios.put.mockResolvedValue({
      data: {
        user: {
          id: 7
        }
      }
    })

    await update(7, {
      name: 'Atualizado'
    })

    expect(axios.put).toHaveBeenCalledWith(
      expect.stringContaining('/api/users/7'),
      {
        user: {
          name: 'Atualizado'
        }
      },
      expect.any(Object)
    )
  })

  it('remove usuário', async () => {
    axios.delete.mockResolvedValue({
      status: 204
    })

    await remove(7)

    expect(axios.delete).toHaveBeenCalledWith(
      expect.stringContaining('/api/users/7'),
      expect.any(Object)
    )
  })
})