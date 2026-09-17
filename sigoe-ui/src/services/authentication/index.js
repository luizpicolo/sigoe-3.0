import axios from 'axios';

const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:3000";

export const isTokenValid = async () => {
  const token = localStorage.getItem('jwt')
  if (!token) return false
  try {
    await axios.get(`${BASE_URL}/api/users/validation`, {
      headers: { Authorization: token }
    })
    return true
  } catch {
    return false
  }
}

export const logout = async () => {
  try {
    await axios.delete(`${BASE_URL}/api/auth/logout`)
    localStorage.removeItem('jwt')
    return true
  } catch (err) {
    return false
  }
}
