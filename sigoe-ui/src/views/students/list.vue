<script setup>
import { computed, onMounted, ref } from 'vue'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Header from '@/components/header.vue'
import ListFilters from '@/components/ListFilters.vue'
import VPagination from '@hennge/vue3-pagination'
import '@hennge/vue3-pagination/dist/vue3-pagination.css'

import { list } from '@/services/students'
import { can, permissionState } from '@/services/permissions'

const breadcrumbItems = [
  { label: 'Home', href: '/' },
  { label: 'Administrador', href: '/' },
  { label: 'Estudantes', href: '/administrador/estudantes/listar' }
]

const page = ref(1)
const amount = ref(10)
const order = ref('id')
const search = ref('')
const students = ref([])
const total = ref(0)
const loading = ref(false)

const showCampus = computed(() => permissionState.user?.super_admin === true)

const loadStudents = async () => {
  loading.value = true

  try {
    const response = await list(page.value, order.value, search.value, amount.value)

    students.value = response?.students || []
    total.value = response?.total || 0
  } finally {
    loading.value = false
  }
}

const updateHandler = (newPage) => {
  page.value = newPage
  loadStudents()
}

const searchStudents = () => {
  page.value = 1
  loadStudents()
}

const changeFilters = () => {
  page.value = 1
  loadStudents()
}

onMounted(loadStudents)
</script>

<template>
  <div class="min-h-screen flex flex-col overflow-x-hidden">
    <Header />

    <div class="flex flex-col md:flex-row flex-1 min-w-0">
      <Sidebar :activePage="'estudantes'" />

      <main class="flex-1 min-w-0 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">Estudantes</h1>

        <ListFilters
          v-model:search="search"
          v-model:order="order"
          v-model:amount="amount"
          search-placeholder="Buscar estudantes..."
          :order-options="[
            { label: 'ID', value: 'id' },
            { label: 'Nome', value: 'name' }
          ]"
          :amount-options="[10, 25, 50, 100]"
          :create-permission="can('students', 'create')"
          create-label="Novo Estudante"
          create-route="/administrador/estudantes/novo"
          create-icon="fa-solid fa-user"
          @search="searchStudents"
          @filter-change="changeFilters"
        />

        <div class="bg-white rounded-md shadow overflow-hidden w-full">
          <div v-if="loading" class="p-6 text-center">
            Carregando estudantes...
          </div>

          <table v-else class="w-full table-fixed divide-y divide-gray-200">
            <thead class="bg-gray-100">
              <tr>
                <th class="w-[8%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  ID
                </th>

                <th class="w-[12%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Foto
                </th>

                <th class="w-[20%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Nome
                </th>

                <th v-if="showCampus" class="w-[17%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Campus
                </th>

                <th class="w-[15%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Turma
                </th>

                <th class="w-[15%] px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Ações
                </th>
              </tr>
            </thead>

            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="student in students" :key="student.id">
                <td class="px-3 py-4 text-sm font-medium text-gray-900 break-words">
                  {{ student.id }}
                </td>

                <td class="px-3 py-4 text-sm text-gray-500">
                  <img :src="student.photo || '/placeholder.svg?height=100&width=100'" width="56" height="56" alt="Foto do estudante" class="rounded-md object-cover">
                </td>

                <td class="px-3 py-4 text-sm text-gray-500 break-words">
                  {{ student.name }}
                </td>

                <td v-if="showCampus" class="px-3 py-4 text-sm text-gray-500 break-words">
                  {{ student.course?.polo?.name || '-' }}
                </td>

                <td class="px-3 py-4 text-sm text-gray-500 break-words">
                  {{ student.school_group?.identifier || student.school_group?.name || '-' }}
                </td>

                <td class="px-3 py-4 text-sm text-gray-500">
                  <Button customClass="w-full bg-green-600 hover:bg-green-700 focus:ring-green-500" :to="`/administrador/estudantes/visualizar/${student.id}`">
                    <i class="fa-solid fa-eye pr-2"></i>
                    Visualizar
                  </Button>
                </td>
              </tr>

              <tr v-if="!students.length">
                <td :colspan="showCampus ? 6 : 5" class="px-6 py-4 text-center text-sm text-gray-500">
                  Nenhum estudante encontrado.
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