import { describe, expect, it } from 'vitest'
import { formatPhone } from '@/utils/phone'

describe('máscara de telefone do responsável', () => {
  it.each([
    ['11987654321', '(11)98765-4321'],
    ['1198765432', '(11)9876-5432'],
    ['(11) 98765-4321', '(11)98765-4321'],
    ['(11) 9876-5432', '(11)9876-5432']
  ])('formata %s como %s', (input, expected) => {
    expect(formatPhone(input)).toBe(expected)
  })

  it('limita a onze dígitos e permite entrada parcial', () => {
    expect(formatPhone('11987654321999')).toBe('(11)98765-4321')
    expect(formatPhone('11')).toBe('(11')
    expect(formatPhone('')).toBe('')
  })
})
