import axios from 'axios'
import { jsPDF } from 'jspdf'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'
const config = () => ({ headers: { Authorization: localStorage.getItem('jwt') } })

export const getIncidentReportOptions = async () => {
  const response = await axios.get(`${BASE_URL}/api/report_incidents/options`, config())
  return response.data
}

const formatDate = value => {
  if (!value) return ''
  const date = new Date(`${value}T00:00:00`)
  return date.toLocaleDateString('pt-BR')
}

const addWrappedText = (pdf, text, x, y, width, lineHeight = 5) => {
  const lines = pdf.splitTextToSize(String(text || ''), width)
  pdf.text(lines, x, y)
  return y + lines.length * lineHeight
}

const createIncidentPdf = incidents => {
  const pdf = new jsPDF({ unit: 'mm', format: 'a4' })
  const margin = 20
  const width = 170
  const pageHeight = 277

  incidents.forEach((incident, index) => {
    if (index > 0) pdf.addPage()
    let y = 25
    pdf.setFont('helvetica', 'bold')
    pdf.setFontSize(16)
    pdf.text('Relatório de ocorrências', 105, y, { align: 'center' })
    y += 18
    pdf.setFontSize(11)
    pdf.text('Aluno(a)', margin, y)
    pdf.setFont('helvetica', 'normal')
    y += 7
    y = addWrappedText(pdf, incident.student, margin, y, width)
    y += 3
    pdf.setFont('helvetica', 'bold')
    pdf.text('Curso', margin, y)
    pdf.setFont('helvetica', 'normal')
    y += 7
    y = addWrappedText(pdf, incident.course, margin, y, width)
    y += 3
    pdf.setFont('helvetica', 'bold')
    pdf.text(`Data ocorrência: ${formatDate(incident.date_incident)} às ${incident.time_incident || ''}`, margin, y)
    y += 7
    pdf.text(`Tipo da ocorrência: ${incident.type_incident || ''}`, margin, y)
    y += 12
    pdf.text('Problema ocorrido', margin, y)
    pdf.setFont('helvetica', 'normal')
    y += 8
    y = addWrappedText(pdf, incident.description, margin, y, width, 5)
    y = Math.min(y + 25, pageHeight - 45)
    pdf.text('Aluno(a)', 62, y, { align: 'center' })
    pdf.text('Responsável', 148, y, { align: 'center' })
    pdf.line(35, y + 3, 89, y + 3)
    pdf.line(121, y + 3, 175, y + 3)
    y += 18
    pdf.text('Data de comparecimento do responsável: ____ de _____________ de 20___', margin, y)
    y += 10
    pdf.text('Arquivado na pasta do estudante em: ____ de _____________ de 20___', margin, y)
  })

  pdf.save('relatorio-ocorrencias.pdf')
}

export const generateIncidentReport = async filters => {
  const response = await axios.get(`${BASE_URL}/api/report_incidents/data`, { ...config(), params: filters })
  createIncidentPdf(response.data)
}
