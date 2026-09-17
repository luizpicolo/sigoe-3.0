import axios from 'axios';

const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:3000";

export const list = async (page = 1, order = 'id', search = null) => {
  const token = localStorage.getItem('jwt')
  if (!token) return false

  try {
    const params = {};
    if (page) params.page = page;
    if (order) params.order = order;
    if (search) params.search = search;

    const response = await axios.get(`${BASE_URL}/api/users`, {
      headers: { Authorization: token },
      params
    });
    
    return {
      users: response.data.users,
      total: response.data.total
    };
  } catch (error) {
    console.error('Erro ao buscar usuários:', error);
    return { users: [], total: 0 };
  }
}

export const find = async (id) => {
  const token = localStorage.getItem('jwt')
  if (!token) return false

  const response = await axios.get(`${BASE_URL}/api/users/${id.value}`, {
      headers: { Authorization: token },
  });

  return {
    user: response.data.user,
  };
}
