import axios from 'axios'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'
const config = () => ({ headers: { Authorization: localStorage.getItem('jwt') }, responseType: 'blob' })

export const generateIncidentReport = async filters => {
  const response = await axios.post(`${BASE_URL}/api/report_incidents`, filters, config())
  const blob = new Blob([response.data], { type: 'application/pdf' })
  const url = window.URL.createObjectURL(blob)
  const link = document.createElement('a')
  link.href = url
  link.download = 'relatorio-ocorrencias.pdf'
  document.body.appendChild(link)
  link.click()
  link.remove()
  window.URL.revokeObjectURL(url)
}
