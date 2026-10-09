<script setup>
import { computed, onMounted, ref } from 'vue'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Header from '@/components/header.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import ListFilters from '@/components/listfilters.vue'
import VPagination from '@hennge/vue3-pagination'
import '@hennge/vue3-pagination/dist/vue3-pagination.css'

import { list, remove } from '@/services/courses'
import { can, permissionState } from '@/services/permissions'
import { success, error, confirm } from '@/utils/sweetPopup2'

const breadcrumbItems = [
  { label: 'Home', href: '/' },
  { label: 'Administrador', href: '/' },
  { label: 'Cursos', href: '/administrador/cursos/listar' }
]

const page = ref(1)
const amount = ref(10)
const order = ref('id')
const search = ref('')
const courses = ref([])
const total = ref(0)
const loading = ref(false)

const showCampus = computed(() => permissionState.user?.super_admin === true)

const loadCourses = async () => {
  loading.value = true

  try {
    const response = await list(page.value, order.value, search.value, amount.value)

    courses.value = response?.courses || []
    total.value = response?.total || 0
  } catch (e) {
    error(e.response?.data?.errors?.join(', ') || 'Não foi possível carregar os cursos.')
    courses.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

const updateHandler = newPage => {
  page.value = newPage
  loadCourses()
}

const searchCourses = () => {
  page.value = 1
  loadCourses()
}

const changeFilters = () => {
  page.value = 1
  loadCourses()
}

const destroy = async id => {
  if (await confirm('Excluir este curso?')) {
    try {
      await remove(id)

      if (await success('Curso removido com sucesso')) {
        await loadCourses()
      }
    } catch (e) {
      error(e.response?.data?.errors?.join(', ') || 'Não foi possível excluir o curso.')
    }
  }
}

onMounted(loadCourses)
</script>

<template>
  <div class="min-h-screen flex flex-col overflow-x-hidden">
    <Header />

    <div class="flex flex-col md:flex-row flex-1 min-w-0">
      <Sidebar :activePage="'cursos'" />

      <main class="flex-1 min-w-0 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">
          Cursos
        </h1>

        <ListFilters
          v-model:search="search"
          v-model:order="order"
          v-model:amount="amount"
          search-placeholder="Buscar cursos..."
          :order-options="[
            { label: 'ID', value: 'id' },
            { label: 'Nome', value: 'name' }
          ]"
          :amount-options="[10, 25, 50, 100]"
          :create-permission="can('courses', 'create')"
          create-label="Novo Curso"
          create-route="/administrador/cursos/novo"
          create-icon="fa-solid fa-plus"
          @search="searchCourses"
          @filter-change="changeFilters"
        />

        <div class="bg-white rounded-md shadow overflow-hidden w-full">
          <div v-if="loading" class="p-6 text-center">
            Carregando cursos...
          </div>

          <table v-else class="w-full table-fixed divide-y divide-gray-200">
            <thead class="bg-gray-100">
              <tr>
                <th class="w-[10%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  ID
                </th>

                <th class="w-[35%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Nome
                </th>

                <th class="w-[20%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Sigla
                </th>

                <th v-if="showCampus" class="w-[20%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Polo
                </th>

                <th class="w-[15%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Ações
                </th>
              </tr>
            </thead>

            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="course in courses" :key="course.id">
                <td class="px-3 py-4 text-sm font-medium text-gray-900 break-words">
                  {{ course.id }}
                </td>

                <td class="px-3 py-4 text-sm text-gray-500 break-words">
                  {{ course.name }}
                </td>

                <td class="px-3 py-4 text-sm text-gray-500 break-words">
                  {{ course.initial }}
                </td>

                <td v-if="showCampus" class="px-3 py-4 text-sm text-gray-500 break-words">
                  {{ course.polo?.name || '-' }}
                </td>

                <td class="px-3 py-4 text-sm text-gray-500">
                  <div class="flex flex-col gap-2">
                    <Button :disabled="!can('courses', 'update')" :to="`/administrador/cursos/editar/${course.id}`" customClass="w-full bg-blue-600 hover:bg-blue-700">
                      <i class="fa-solid fa-edit pr-2"></i>
                      Editar
                    </Button>

                    <Button :disabled="!can('courses', 'destroy')" @click="destroy(course.id)" customClass="w-full bg-red-600 hover:bg-red-700">
                      <i class="fa-solid fa-trash pr-2"></i>
                      Excluir
                    </Button>
                  </div>
                </td>
              </tr>

              <tr v-if="!courses.length">
                <td :colspan="showCampus ? 5 : 4" class="px-6 py-4 text-center text-sm text-gray-500">
                  Nenhum curso encontrado.
                </td>
              </tr>
            </tbody>
          </table>

          <div class="flex justify-end items-end p-4">
            <VPagination v-model="page" :pages="Math.max(1, Math.ceil(total / amount))" :range-size="2" active-color="#00a63e" @update:modelValue="updateHandler" />
          </div>
        </div>
      </main>
    </div>
  </div>
</template>