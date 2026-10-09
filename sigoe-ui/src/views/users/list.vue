<script setup>
import { ref, computed, onMounted } from 'vue'
import { list } from '@/services/users'
import { can, permissionState } from '@/services/permissions'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Header from '@/components/header.vue'
import ListFilters from '@/components/listfilters.vue'
import VPagination from '@hennge/vue3-pagination'
import '@hennge/vue3-pagination/dist/vue3-pagination.css'
import { error } from '@/utils/sweetPopup2'

const users = ref([])
const usersTotal = ref(0)
const page = ref(1)
const amount = ref(10)
const orderby = ref('id')
const search = ref('')
const loading = ref(false)

const showCampus = computed(() => permissionState.user?.super_admin === true)

const breadcrumbItems = [
  { label: 'Home', href: '/' },
  { label: 'Administrador', href: '/administrador' },
  { label: 'Usuários', href: '/administrador/usuarios' }
]

const fetchUsers = async () => {
  loading.value = true

  try {
    const response = await list(page.value, orderby.value, search.value, amount.value)

    users.value = response?.users || []
    usersTotal.value = response?.total || 0
  } catch (e) {
    error(e.response?.data?.errors?.join(', ') || 'Não foi possível carregar os usuários.')
    users.value = []
    usersTotal.value = 0
  } finally {
    loading.value = false
  }
}

const handleFiltersChange = () => {
  page.value = 1
  fetchUsers()
}

const handleSearch = () => {
  page.value = 1
  fetchUsers()
}

const handlerUpdatePagination = newPage => {
  page.value = newPage
  fetchUsers()
}

onMounted(fetchUsers)
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'usuarios'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">
          Usuários
        </h1>

        <ListFilters
          v-model:search="search"
          v-model:order="orderby"
          v-model:amount="amount"
          search-placeholder="Buscar usuários..."
          :order-options="[
            { label: 'ID', value: 'id' },
            { label: 'Nome', value: 'name' }
          ]"
          :amount-options="[10, 25, 50, 100]"
          :create-permission="can('users', 'create')"
          create-label="Novo Usuário"
          create-route="/administrador/usuarios/novo"
          create-icon="fa-solid fa-user"
          @search="handleSearch"
          @filter-change="handleFiltersChange"
        />

        <div class="bg-white rounded-md shadow overflow-hidden">
          <div v-if="loading" class="p-6 text-center text-gray-600">
            Carregando usuários...
          </div>

          <table v-else class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-100">
              <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  ID
                </th>

                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Nome
                </th>

                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Email
                </th>

                <th v-if="showCampus" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Campus
                </th>

                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Usuário
                </th>

                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Admin
                </th>

                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Ativo
                </th>

                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">
                  Ações
                </th>
              </tr>
            </thead>

            <tbody>
              <tr v-for="user in users" :key="user.id" class="bg-white divide-y divide-gray-200">
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                  {{ user.id }}
                </td>

                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                  {{ user.name }}
                </td>

                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {{ user.email }}
                </td>

                <td v-if="showCampus" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {{ user.polo?.name || '-' }}
                </td>

                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {{ user.username }}
                </td>

                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  <span v-if="user.admin" class="text-green-600">
                    <i class="fa-solid fa-circle-check"></i>
                    Sim
                  </span>

                  <span v-else class="text-red-600">
                    <i class="fa-solid fa-circle-xmark"></i>
                    Não
                  </span>
                </td>

                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  <span v-if="user.status" class="text-green-600">
                    <i class="fa-solid fa-circle-check"></i>
                    Sim
                  </span>

                  <span v-else class="text-red-600">
                    <i class="fa-solid fa-circle-xmark"></i>
                    Não
                  </span>
                </td>

                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  <Button customClass="w-full bg-green-600 hover:bg-green-700 focus:ring-green-500" :to="`/administrador/usuarios/visualizar/${user.id}`">
                    <i class="fa-solid fa-eye pr-2"></i>
                    Visualizar
                  </Button>
                </td>
              </tr>

              <tr v-if="!users.length">
                <td :colspan="showCampus ? 8 : 7" class="px-6 py-4 text-center text-sm text-gray-500">
                  Nenhum usuário encontrado.
                </td>
              </tr>
            </tbody>
          </table>

          <div class="flex justify-end items-end p-4">
            <VPagination v-model="page" :pages="Math.max(1, Math.ceil(usersTotal / amount))" :range-size="2" active-color="#00a63e" @update:modelValue="handlerUpdatePagination" />
          </div>
        </div>
      </main>
    </div>
  </div>
</template>