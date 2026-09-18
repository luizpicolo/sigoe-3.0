import axios from 'axios'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'
const config = () => ({ headers: { Authorization: localStorage.getItem('jwt') } })

export const list = async (page = 1, order = 'id', search = null, amount = 10) => {
  const response = await axios.get(`${BASE_URL}/api/incidents`, { ...config(), params: { page, order, search, amount } })
  return response.data
}
