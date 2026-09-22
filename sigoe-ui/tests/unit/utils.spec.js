import Swal from 'sweetalert2'
import { describe, expect, it, vi, beforeEach } from 'vitest'
import { formatDate, formatTime, avatar } from '@/utils'
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
    expect(avatar('uploads/avatar.png')).toBe('https://sigoe.na.ifms.edu.br/uploads/avatar.png')
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
