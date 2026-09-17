import axios from 'axios';

const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:3000";

export const list = async (page = 1, order = 'id', search = null, amount = 10) => {
  const token = localStorage.getItem('jwt')
  if (!token) return false

  try {
    const params = { page, order, amount };
    if (search) params.search = search;

    const response = await axios.get(`${BASE_URL}/api/students`, {
      headers: { Authorization: token },
      params
    });

    return {
      students: response.data.students,
      total: response.data.total
    };
  } catch (error) {
    console.error('Erro ao buscar estudantes:', error);
    return { students: [], total: 0 };
  }
}

export const find = async (id) => {
  const token = localStorage.getItem('jwt')
  if (!token) return false

  try {
    const response = await axios.get(`${BASE_URL}/api/students/${id}`, {
      headers: { Authorization: token },
    });

    return {
      student: response.data.student,
    };
  } catch (error) {
    console.error('Erro ao buscar estudante:', error);
    return { student: null };
  }
}
