import axios from 'axios'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'
const config = () => ({ headers: { Authorization: localStorage.getItem('jwt') } })

export const getIncidentReportOptions = async () => {
  const response = await axios.get(`${BASE_URL}/api/report_incidents/options`, config())
  return response.data
}

export const generateIncidentReport = async filters => {
  const response = await axios.post(`${BASE_URL}/api/report_incidents`, filters, { ...config(), responseType: 'blob' })
  const url = window.URL.createObjectURL(response.data)
  const link = document.createElement('a')
  link.href = url
  link.download = 'relatorio-ocorrencias.pdf'
  document.body.appendChild(link)
  link.click()
  link.remove()
  window.URL.revokeObjectURL(url)
}
