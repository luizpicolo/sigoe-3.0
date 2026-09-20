<script setup>
import { onMounted, computed, ref } from 'vue'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Input from '@/components/ui/input.vue'
import Header from '@/components/header.vue'
import { list, remove } from '@/services/school_groups'
import { can, permissionState } from '@/services/permissions'
import VPagination from '@hennge/vue3-pagination'
import '@hennge/vue3-pagination/dist/vue3-pagination.css'
import { error, confirm, success } from '@/utils/sweetPopup2'

const breadcrumbItems = [{ label: 'Home', href: '/' }, { label: 'Administrador', href: '/' }, { label: 'Turmas', href: '/administrador/turmas/listar' }]

const page = ref(1)
const amount = ref(10)
const order = ref('id')
const search = ref('')
const groups = ref([])
const total = ref(0)
const loading = ref(false)
const showCampus = computed(() => permissionState.user?.super_admin === true)

const loadGroups = async () => {
  loading.value = true

  try {
    const r = await list(page.value, order.value, search.value, amount.value)
    groups.value = r?.school_groups || []
    total.value = r?.total || 0
  } catch (e) {
    error('Não foi possível carregar as turmas.')
    groups.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

const updateHandler = p => {
  page.value = p
  loadGroups()
}

const searchGroups = () => {
  page.value = 1
  loadGroups()
}

const changeFilters = () => {
  page.value = 1
  loadGroups()
}

const destroy = async id => {
  if (await confirm('Excluir esta turma?')){
    try {
      await remove(id)
      success("Turma excluida com sucesso");
      await loadGroups()
    } catch (e) {
      error('Não foi possível excluir a turma.')
    }
  }
}

onMounted(loadGroups)
</script>

<template>
  <div class="min-h-screen flex flex-col overflow-x-hidden">
    <Header />
    <div class="flex flex-col md:flex-row flex-1 min-w-0">
      <Sidebar :activePage="'turmas'" />
      <main class="flex-1 min-w-0 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <h1 class="text-2xl font-bold mb-6">Turmas</h1>
        <div class="bg-white rounded-md shadow p-4 mb-6">
          <div class="flex flex-wrap gap-2">
            <Button :disabled="!can('classes', 'create')" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500" to="/administrador/turmas/novo">
              <i class="fa-solid fa-plus"></i>
              Nova Turma
            </Button>
            <div class="flex items-center gap-2 ml-auto">
              <span class="text-sm">Ordenar por</span>
              <select v-model="order" @change="changeFilters" class="block w-[180px] px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm sm:text-sm">
                <option value="id">ID</option>
                <option value="name">Nome</option>
              </select>
            </div>
            <div class="flex items-center gap-2">
              <span class="text-sm">Total</span>
              <select v-model="amount" @change="changeFilters" class="block w-[80px] px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm sm:text-sm">
                <option :value="10">10</option>
                <option :value="25">25</option>
                <option :value="50">50</option>
                <option :value="100">100</option>
              </select>
            </div>
            <div class="flex items-center gap-2">
              <Input v-model="search" type="text" placeholder="Buscar..." class="w-[200px]" />
              <Button @click="searchGroups" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500">
                <i class="fa-solid fa-magnifying-glass"></i>
                Busca
              </Button>
            </div>
          </div>
        </div>
        <div class="bg-white rounded-md shadow overflow-hidden w-full">
          <div v-if="loading" class="p-6 text-center">
            Carregando turmas...
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
                  Identificador
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
              <tr v-for="group in groups" :key="group.id">
                <td class="px-3 py-4 text-sm font-medium text-gray-900 break-words">
                  {{ group.id }}
                </td>
                <td class="px-3 py-4 text-sm text-gray-500 break-words">
                  {{ group.name }}
                </td>
                <td class="px-3 py-4 text-sm text-gray-500 break-words">
                  {{ group.identifier || "Sem identificador" }}
                </td>
                <td v-if="showCampus" class="px-3 py-4 text-sm text-gray-500 break-words">
                  {{ group.polo?.name || '-' }}
                </td>
                <td class="px-3 py-4 text-sm text-gray-500">
                  <div class="flex flex-col gap-2">
                    <Button :disabled="!can('classes', 'update')" :to="`/administrador/turmas/editar/${group.id}`" customClass="w-full bg-blue-600 hover:bg-blue-700">
                      Editar
                    </Button>
                    <Button :disabled="!can('classes', 'destroy')" @click="destroy(group.id)" customClass="w-full bg-red-600 hover:bg-red-700">
                      Excluir
                    </Button>
                  </div>
                </td>
              </tr>
              <tr v-if="!groups.length">
                <td colspan="5" class="px-6 py-4 text-center text-sm text-gray-500">
                  Nenhuma turma encontrada.
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