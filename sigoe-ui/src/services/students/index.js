import axios from 'axios';

const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:3000";

const authConfig = () => ({ headers: { Authorization: localStorage.getItem('jwt') } });

export const list = async (page = 1, order = 'id', search = null, amount = 10) => {
  const token = localStorage.getItem('jwt')
  if (!token) return false

  try {
    const params = { page, order, amount };
    if (search) params.search = search;
    const response = await axios.get(`${BASE_URL}/api/students`, { headers: { Authorization: token }, params });
    return { students: response.data.students, total: response.data.total };
  } catch (error) {
    console.error('Erro ao buscar estudantes:', error);
    return { students: [], total: 0 };
  }
}

export const find = async id => {
  const token = localStorage.getItem('jwt')
  if (!token) return false
  try {
    const response = await axios.get(`${BASE_URL}/api/students/${id}`, authConfig());
    return { student: response.data.student };
  } catch (error) {
    console.error('Erro ao buscar estudante:', error);
    return { student: null };
  }
}

export const create = async student => {
  const token = localStorage.getItem('jwt')
  if (!token) return false
  try {
    const response = await axios.post(`${BASE_URL}/api/students`, { student }, authConfig());
    return { student: response.data.student, error: null };
  } catch (error) {
    console.error('Erro ao cadastrar estudante:', error);
    return { student: null, error: error.response?.data?.errors || ['Erro ao cadastrar estudante.'] };
  }
}

export const options = async () => {
  const token = localStorage.getItem('jwt')
  if (!token) return false
  try {
    const response = await axios.get(`${BASE_URL}/api/students/options`, authConfig());
    return { courses: response.data.courses, school_groups: response.data.school_groups, course_situations: response.data.course_situations };
  } catch (error) {
    console.error('Erro ao buscar opções para cadastro de estudante:', error);
    return { courses: [], school_groups: [], course_situations: [] };
  }
}

export const update = async (id, student) => {
  const token = localStorage.getItem('jwt')
  if (!token) return false
  try {
    const response = await axios.patch(`${BASE_URL}/api/students/${id}`, { student }, authConfig());
    return { student: response.data.student, error: null };
  } catch (error) {
    console.error('Erro ao atualizar estudante:', error);
    return { student: null, error: error.response?.data?.errors || ['Erro ao atualizar estudante.'] };
  }
}

export const remove = async id => {
  const token = localStorage.getItem('jwt')
  if (!token) return false
  return axios.delete(`${BASE_URL}/api/students/${id}`, authConfig())
}
