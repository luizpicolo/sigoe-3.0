<script setup>
import { computed, onMounted, ref } from 'vue'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Input from '@/components/ui/input.vue'
import { list, remove } from '@/services/courses'
import { can } from '@/services/permissions'

const breadcrumbItems = [
  { label: 'Home', href: '/' },
  { label: 'Administrador', href: '/' },
  { label: 'Cursos', href: '/administrador/cursos/listar' }
]

const courses = ref([])
const search = ref('')
const loading = ref(false)
const error = ref('')

const filteredCourses = computed(() => {
  const term = search.value.trim().toLowerCase()
  if (!term) return courses.value
  return courses.value.filter(course =>
    [course.id, course.name, course.initial, course.polo?.name]
      .filter(value => value !== null && value !== undefined)
      .some(value => String(value).toLowerCase().includes(term))
  )
})

const loadCourses = async () => {
  loading.value = true
  error.value = ''
  try {
    const response = await list()
    courses.value = response?.courses || []
  } catch (e) {
    error.value = 'Não foi possível carregar os cursos.'
  } finally {
    loading.value = false
  }
}

const destroy = async (id) => {
  if (!confirm('Excluir este curso?')) return
  try {
    await remove(id)
    await loadCourses()
  } catch (e) {
    error.value = 'Não foi possível excluir o curso.'
  }
}

onMounted(loadCourses)
</script>

<template>
  <div class="min-h-screen flex flex-col overflow-x-hidden">
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center">
      <div class="flex items-center"><img src="/logo_ifms.png" width="160"></div>
      <div class="text-sm">SIGOE - Controle de ocorrências escolares - <span class="text-green-600">Sair</span></div>
    </header>

    <div class="flex flex-col md:flex-row flex-1 min-w-0">
      <Sidebar activePage="cursos" />
      <main class="flex-1 min-w-0 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <h1 class="text-2xl font-bold mb-6">Cursos</h1>

        <div class="bg-white rounded-md shadow p-4 mb-6">
          <div class="flex flex-wrap gap-2">
            <Button v-if="can('courses', 'create')" to="/administrador/cursos/novo" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500">
              <i class="fa-solid fa-plus"></i>
              Novo Curso
            </Button>
            <div class="flex items-center gap-2 ml-auto">
              <Input v-model="search" type="text" placeholder="Buscar..." class="w-[220px]" />
              <Button customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500"><i class="fa-solid fa-magnifying-glass"></i>Busca</Button>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-md shadow overflow-hidden w-full">
          <div v-if="loading" class="p-6 text-center">Carregando cursos...</div>
          <table v-else class="w-full table-fixed divide-y divide-gray-200">
            <thead class="bg-gray-100"><tr>
              <th class="w-[10%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID</th>
              <th class="w-[35%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nome</th>
              <th class="w-[20%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Sigla</th>
              <th class="w-[20%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Polo</th>
              <th class="w-[15%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Ações</th>
            </tr></thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="course in filteredCourses" :key="course.id">
                <td class="px-3 py-4 text-sm font-medium text-gray-900 break-words">{{ course.id }}</td>
                <td class="px-3 py-4 text-sm text-gray-500 break-words">{{ course.name }}</td>
                <td class="px-3 py-4 text-sm text-gray-500 break-words">{{ course.initial }}</td>
                <td class="px-3 py-4 text-sm text-gray-500 break-words">{{ course.polo?.name || '-' }}</td>
                <td class="px-3 py-4 text-sm text-gray-500"><div class="flex flex-col gap-2"><Button v-if="can('courses', 'update')" :to="`/administrador/cursos/editar/${course.id}`" customClass="w-full bg-blue-600 hover:bg-blue-700">Editar</Button><Button v-if="can('courses', 'destroy')" @click="destroy(course.id)" customClass="w-full bg-red-600 hover:bg-red-700">Excluir</Button></div></td>
              </tr>
              <tr v-if="!filteredCourses.length"><td colspan="5" class="px-6 py-4 text-center text-sm text-gray-500">Nenhum curso encontrado.</td></tr>
            </tbody>
          </table>
        </div>
      </main>
    </div>
  </div>
</template>
