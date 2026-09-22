import axios from 'axios'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { isTokenValid, logout } from '@/services/authentication'
import { can, clearPermissions, loadCurrentPermissions, permissionState, getUserPermissions, saveUserPermissions } from '@/services/permissions'

vi.mock('axios', () => ({ default: { get: vi.fn(), put: vi.fn(), delete: vi.fn() } }))

describe('autenticação', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    localStorage.clear()
    clearPermissions()
  })

  it('rejeita validação sem token', async () => {
    await expect(isTokenValid()).resolves.toBe(false)
    expect(axios.get).not.toHaveBeenCalled()
  })

  it('valida token e carrega permissões', async () => {
    localStorage.setItem('jwt', 'token')
    axios.get.mockResolvedValue({ data: {} })
    await expect(isTokenValid()).resolves.toBe(true)
    expect(axios.get).toHaveBeenCalled()
  })

  it('remove token ao falhar na validação', async () => {
    localStorage.setItem('jwt', 'token')
    axios.get.mockRejectedValue(new Error('unauthorized'))
    await expect(isTokenValid()).resolves.toBe(false)
    expect(localStorage.getItem('jwt')).toBeNull()
  })

  it('encerra sessão e limpa estado local', async () => {
    localStorage.setItem('jwt', 'token')
    axios.delete.mockResolvedValue({})
    await expect(logout()).resolves.toBe(true)
    expect(localStorage.getItem('jwt')).toBeNull()
  })
})

describe('permissões', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    localStorage.clear()
    clearPermissions()
  })

  it('retorna falso quando não há token', async () => {
    await loadCurrentPermissions()
    expect(permissionState.loaded).toBe(false)
    expect(permissionState.admin).toBe(false)
  })

  it('carrega permissões da API', async () => {
    localStorage.setItem('jwt', 'token')
    axios.get.mockResolvedValue({ data: { admin: false, permissions: { users: { read: true } }, entities: [] } })
    await loadCurrentPermissions()
    expect(permissionState.loaded).toBe(true)
    expect(can('users', 'read')).toBe(true)
    expect(can('users', 'delete')).toBe(false)
  })

  it('permite todas as ações para administrador', () => {
    permissionState.admin = true
    expect(can('qualquer-entidade', 'qualquer-acao')).toBe(true)
  })

  it('consulta e salva permissões de usuário', async () => {
    localStorage.setItem('jwt', 'token')
    axios.get.mockResolvedValue({ data: { permissions: {} } })
    axios.put.mockResolvedValue({ data: { ok: true } })
    await expect(getUserPermissions(3)).resolves.toEqual({ permissions: {} })
    await expect(saveUserPermissions(3, { users: { read: true } })).resolves.toEqual({ ok: true })
    expect(axios.put).toHaveBeenCalled()
  })
})
