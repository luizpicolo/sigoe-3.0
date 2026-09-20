import axios from 'axios'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'

const authConfig = () => ({
  headers: {
    Authorization: localStorage.getItem('jwt')
  }
})

export const list = async (page = 1, order = 'id', search = null) => {
  const token = localStorage.getItem('jwt')

  if (!token) return false

  try {
    const params = {}

    if (page) params.page = page
    if (order) params.order = order
    if (search) params.search = search

    const response = await axios.get(`${BASE_URL}/api/users`, {
      ...authConfig(),
      params
    })

    return {
      users: response.data.users,
      total: response.data.total
    }
  } catch (error) {
    console.error('Erro ao buscar usuários:', error)

    return {
      users: [],
      total: 0
    }
  }
}

export const find = async id => {
  const userId = typeof id === 'object' && id !== null ? id.value : id
  const response = await axios.get(`${BASE_URL}/api/users/${userId}`, authConfig())

  return {
    user: response.data.user
  }
}

export const options = async () => {
  return (await axios.get(`${BASE_URL}/api/users/options`, authConfig())).data
}

export const create = async user => {
  const formData = new FormData()

  Object.entries(user).forEach(([key, value]) => {
    if (value !== null && value !== undefined) {
      formData.append(`user[${key}]`, value)
    }
  })

  const response = await axios.post(`${BASE_URL}/api/users`, formData, {
    headers: {
      ...authConfig().headers,
      'Content-Type': 'multipart/form-data'
    }
  })

  return response.data
}

export const update = async (id, user) => {
  return (await axios.put(`${BASE_URL}/api/users/${id}`, { user }, authConfig())).data
}

export const changePassword = async (current_password, new_password, password_confirmation) => {
  return (await axios.put(`${BASE_URL}/api/users/change_password`, { current_password, new_password, password_confirmation }, authConfig())).data
}

export const remove = async id => {
  return axios.delete(`${BASE_URL}/api/users/${id}`, authConfig())
}