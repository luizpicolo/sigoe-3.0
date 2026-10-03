import { beforeEach, vi } from 'vitest'

beforeEach(() => {
  vi.restoreAllMocks()
  localStorage.clear()
  localStorage.setItem('jwt', 'test-token')
})
