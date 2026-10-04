import { describe, expect, it, vi, beforeEach } from 'vitest'

const mockCreateIncidentPdf = vi.fn()

vi.mock('axios', () => ({
  default: {
    get: vi.fn()
  }
}))

describe('relatório de ocorrência', () => {
  beforeEach(() => {
    vi.resetModules()
    mockCreateIncidentPdf.mockClear()
  })

  it('gera o relatório somente com a ocorrência informada', async () => {
    const report = await import('@/services/reports/incidents')
    const incident = {
      student: { name: 'Maria' },
      course: { name: 'Informática' },
      date_incident: '2026-09-24',
      time_incident: '10:30',
      type_incident: { name: 'Indisciplina' },
      description: 'Descrição',
      sanction: 'written_warning',
      soluction: 'Solução',
      student_duties: [{ item: 'Direito' }],
      prohibition_and_responsibilities: [{ item: 'Proibição' }]
    }

    const open = window.open
    window.open = vi.fn(() => ({
      document: {
        open: vi.fn(),
        write: vi.fn(),
        close: vi.fn()
      },
      focus: vi.fn(),
      print: vi.fn()
    }))

    await report.generateIncidentReportFromIncident(incident)

    expect(window.open).toHaveBeenCalledWith('', '_blank', 'width=900,height=700')
    window.open = open
  })
})
