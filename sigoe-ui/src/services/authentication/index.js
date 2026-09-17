import axios from 'axios'
import { loadCurrentPermissions, clearPermissions } from '@/services/permissions'

const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:3000"

const authorizationHeaders = () => {
  const token = localStorage.getItem('jwt')
  return token ? { Authorization: token } : {}
}

export const isTokenValid = async () => {
  const token = localStorage.getItem('jwt')
  if (!token) return false

  try {
    await axios.get(`${BASE_URL}/api/users/validation`, {
      headers: authorizationHeaders()
    })
    await loadCurrentPermissions()
    return true
  } catch {
    localStorage.removeItem('jwt')
    clearPermissions()
    return false
  }
}

export const logout = async () => {
  try {
    await axios.delete(`${BASE_URL}/api/auth/logout`, {
      headers: authorizationHeaders()
    })
    localStorage.removeItem('jwt')
    clearPermissions()
    return true
  } catch {
    return false
  }
}
