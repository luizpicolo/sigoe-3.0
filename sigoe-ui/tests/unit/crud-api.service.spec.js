import axios from 'axios'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import * as students from '@/services/students'
import * as courses from '@/services/courses'
import * as schoolGroups from '@/services/school_groups'

vi.mock('axios', () => ({ default: { get: vi.fn(), post: vi.fn(), patch: vi.fn(), delete: vi.fn() } }))

describe('serviços CRUD da API', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    localStorage.setItem('jwt', 'token')
  })

  it.each([
    ['estudantes', students, '/api/students', 'student', { name: 'Estudante' }],
    ['cursos', courses, '/api/courses', 'course', { name: 'Curso' }],
    ['turmas', schoolGroups, '/api/school_groups', 'school_group', { name: 'Turma' }]
  ])('executa o CRUD de %s usando a API', async (_, service, path, key, payload) => {
    axios.get.mockResolvedValue({ data: { [key]: { id: 1 }, [key + 's']: [], total: 1 } })
    axios.post.mockResolvedValue({ data: { [key]: { id: 1 } } })
    axios.patch.mockResolvedValue({ data: { [key]: { id: 1 } } })
    axios.delete.mockResolvedValue({ status: 204 })

    await service.list()
    await service.find(1)
    await service.create(payload)
    await service.update(1, payload)
    await service.remove(1)

    expect(axios.get).toHaveBeenCalledWith(expect.stringContaining(path), expect.any(Object))
    expect(axios.post).toHaveBeenCalledWith(expect.stringContaining(path), { [key]: payload }, expect.any(Object))
    expect(axios.patch).toHaveBeenCalledWith(expect.stringContaining(`${path}/1`), { [key]: payload }, expect.any(Object))
    expect(axios.delete).toHaveBeenCalledWith(expect.stringContaining(`${path}/1`), expect.any(Object))
  })

  it('não chama a API sem autenticação para estudantes', async () => {
    localStorage.removeItem('jwt')
    await expect(students.remove(1)).resolves.toBe(false)
    expect(axios.delete).not.toHaveBeenCalled()
  })
})
