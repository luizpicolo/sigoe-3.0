import { describe, expect, it } from 'vitest'
import IncidentShow from '@/views/incidents/show.vue'

describe('aceitação: visualização de ocorrência', () => {
  it('carrega a view de detalhes da ocorrência', () => {
    expect(IncidentShow).toBeDefined()
  })
})
