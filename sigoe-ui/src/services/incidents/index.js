import axios from 'axios'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'
const config = () => ({ headers: { Authorization: localStorage.getItem('jwt') } })

export const list = async (page = 1, order = 'id', search = null, amount = 10) => {
  const response = await axios.get(`${BASE_URL}/api/incidents`, { ...config(), params: { page, order, search, amount } })
  return response.data
}

export const options = async () => {
  const response = await axios.get(`${BASE_URL}/api/incidents/options`, config())
  return response.data
}

export const find = async (id) => {
  const response = await axios.get(`${BASE_URL}/api/incidents/${id}`, config())
  return response.data
}

export const create = async (incident) => {
  try {
    const response = await axios.post(`${BASE_URL}/api/incidents`, { incident }, config())
    return { ...response.data, error: null }
  } catch (error) {
    return { incident: null, error: error.response?.data?.errors || 'Não foi possível cadastrar a ocorrência.' }
  }
}
