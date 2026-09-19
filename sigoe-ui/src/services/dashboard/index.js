import axios from 'axios'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'
const config = () => ({ headers: { Authorization: localStorage.getItem('jwt') } })

export const show = async () => {
  const response = await axios.get(`${BASE_URL}/api/dashboard`, config())
  return response.data
}
