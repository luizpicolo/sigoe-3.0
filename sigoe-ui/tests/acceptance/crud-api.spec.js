import axios from 'axios'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import * as students from '@/services/students'
import * as courses from '@/services/courses'
import * as schoolGroups from '@/services/school_groups'

vi.mock('axios', () => ({ default: { get: vi.fn(), post: vi.fn(), patch: vi.fn(), delete: vi.fn() } }))

describe('aceitação: fluxos CRUD da API', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    localStorage.setItem('jwt', 'token')
    axios.get.mockResolvedValue({ data: { students: [], courses: [], school_groups: [], total: 0, student: { id: 1 }, course: { id: 1 }, school_group: { id: 1 } } })
    axios.post.mockResolvedValue({ data: { student: { id: 1 }, course: { id: 1 }, school_group: { id: 1 } } })
    axios.patch.mockResolvedValue({ data: { student: { id: 1 }, course: { id: 1 }, school_group: { id: 1 } } })
    axios.delete.mockResolvedValue({ status: 204 })
  })

  it.each([
    ['estudante', students, { name: 'Estudante' }],
    ['curso', courses, { name: 'Curso' }],
    ['turma', schoolGroups, { name: 'Turma' }]
  ])('conclui o fluxo de criação, consulta, edição e exclusão de %s', async (_, service, payload) => {
    const created = await service.create(payload)
    const found = await service.find(1)
    const updated = await service.update(1, payload)
    const removed = await service.remove(1)

    expect(created).toBeTruthy()
    expect(found).toBeTruthy()
    expect(updated).toBeTruthy()
    expect(removed).toBeTruthy()
    expect(axios.post).toHaveBeenCalledOnce()
    expect(axios.patch).toHaveBeenCalledOnce()
    expect(axios.delete).toHaveBeenCalledOnce()
  })
})
