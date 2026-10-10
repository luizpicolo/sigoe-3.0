import Swal from 'sweetalert2'
import { describe, expect, it, vi, beforeEach } from 'vitest'
import { formatDate, formatTime, avatar } from '@/utils'
import { version } from '@/utils/version'
import { success, error, warning, confirm } from '@/utils/sweetPopup2'

vi.mock('sweetalert2', () => ({ default: { fire: vi.fn() } }))

describe('utilitários de formatação', () => {
  it('formata datas em pt-BR', () => {
    expect(formatDate('2025-04-30')).toBe('30/04/25')
    expect(formatDate(null)).toBe('')
  })

  it('formata horários', () => {
    expect(formatTime('2025-04-30T14:35:00')).toMatch(/14:35/)
    expect(formatTime(null)).toBe('')
  })

  it('monta URL de avatar', () => {
    expect(avatar('uploads/avatar.png')).toBe('http://localhost:3000/uploads/avatar.png')
    expect(avatar('')).toBe('')
  })
})

describe('SweetPopup2', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    Swal.fire.mockResolvedValue({ isConfirmed: true })
  })

  it.each([
    [success, 'success', 'Sucesso'],
    [error, 'error', 'Erro'],
    [warning, 'warning', 'Atenção'],
  ])('exibe alerta %s', async (handler, icon, title) => {
    await handler('Mensagem')
    expect(Swal.fire).toHaveBeenCalledWith(expect.objectContaining({ icon, title, text: 'Mensagem' }))
  })

  it('retorna confirmação booleana', async () => {
    await expect(confirm('Confirmar?')).resolves.toBe(true)
    expect(Swal.fire).toHaveBeenCalledWith(expect.objectContaining({ showCancelButton: true }))
  })
})

describe('version', () => {
  beforeEach(() => {
    vi.restoreAllMocks()
  })

  it('retorna a versão que está no package.json', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({
        version: '1.2.3'
      })
    }))

    await expect(version()).resolves.toBe('1.2.3')
  })

  it('retorna uma string com a versão', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: true,
      json: vi.fn().mockResolvedValue({
        version: '1.2.3'
      })
    }))

    const resultado = await version()

    expect(resultado).toEqual(expect.any(String))
    expect(resultado).toMatch(/^\d+\.\d+\.\d+$/)
  })

  it('retorna a versão padrão quando ocorre um erro', async () => {
    vi.stubGlobal('fetch', vi.fn().mockRejectedValue(
      new Error('Falha na requisição')
    ))

    await expect(version()).resolves.toBe('0.0.0')
  })

  it('retorna a versão padrão quando a resposta HTTP não é válida', async () => {
    vi.stubGlobal('fetch', vi.fn().mockResolvedValue({
      ok: false,
      json: vi.fn()
    }))

    await expect(version()).resolves.toBe('0.0.0')
  })
})
