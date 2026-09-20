import axios from 'axios'
import { reactive } from 'vue'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'

const authorizationConfig = () => ({
  headers: { Authorization: localStorage.getItem('jwt') }
})

export const permissionState = reactive({
  loaded: false,
  loading: false,
  admin: false,
  user: null,
  entities: [],
  permissions: {}
})

const resetState = () => {
  permissionState.loaded = false
  permissionState.loading = false
  permissionState.admin = false
  permissionState.user = null
  permissionState.entities = []
  permissionState.permissions = {}
}

export const clearPermissions = () => resetState()

export const loadCurrentPermissions = async (force = false) => {
  if (permissionState.loaded && !force) return permissionState

  const token = localStorage.getItem('jwt')
  if (!token) {
    resetState()
    return permissionState
  }

  permissionState.loading = true
  try {
    const response = await axios.get(`${BASE_URL}/api/permissions/current`, authorizationConfig())
    Object.assign(permissionState, response.data, { loaded: true, loading: false })
    return permissionState
  } catch (error) {
    console.error('Erro ao carregar permissões:', error)
    resetState()
    return permissionState
  } finally {
    permissionState.loading = false
  }
}

export const can = (entity, action = 'read') => {
  if (permissionState.admin) return true

  const entityPermissions = permissionState.permissions?.[entity]
  if (!entityPermissions) return false

  // A permissão "Aplicar sanção" usa o campo legado can_extras no backend.
  const permissionKey = action === 'sanction' ? 'can_extras' : action

  return entityPermissions[permissionKey] === true || entityPermissions[`can_${permissionKey}`] === true
}

export const getUserPermissions = async (userId) => {
  const response = await axios.get(
    `${BASE_URL}/api/users/${userId}/permissions`,
    authorizationConfig()
  )
  return response.data
}

export const saveUserPermissions = async (userId, permissions) => {
  const response = await axios.put(
    `${BASE_URL}/api/users/${userId}/permissions`,
    { permissions },
    authorizationConfig()
  )
  return response.data
}
