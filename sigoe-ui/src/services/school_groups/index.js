import axios from 'axios'

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3000'
const config = () => ({ headers: { Authorization: localStorage.getItem('jwt') } })

export const list = async (page = 1, order = 'id', search = null, amount = 10) => {
  const response = await axios.get(`${BASE_URL}/api/school_groups`, {
    ...config(),
    params: { page, order, search, amount }
  })
  return response.data
}

export const find = async id => (await axios.get(`${BASE_URL}/api/school_groups/${id}`, config())).data.school_group
export const create = async school_group => (await axios.post(`${BASE_URL}/api/school_groups`, { school_group }, config())).data
export const update = async (id, school_group) => (await axios.patch(`${BASE_URL}/api/school_groups/${id}`, { school_group }, config())).data
export const remove = async id => axios.delete(`${BASE_URL}/api/school_groups/${id}`, config())
