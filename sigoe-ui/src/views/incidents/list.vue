<script setup>
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Input from '@/components/ui/input.vue'
import { onMounted, ref } from 'vue'
import { list } from '@/services/incidents'
import { can, permissionState } from '@/services/permissions'
import VPagination from '@hennge/vue3-pagination'
import '@hennge/vue3-pagination/dist/vue3-pagination.css'

const breadcrumbItems = [{ label: 'Home', href: '/' }, { label: 'Administrador', href: '/' }, { label: 'Ocorrências', href: '/ocorrencias/ocorrencias/listar' }]
const page = ref(1)
const amount = ref(10)
const order = ref('id')
const search = ref('')
const incidents = ref([])
const total = ref(0)
const loading = ref(false)

const canAccessIncident = incident => incident.visibility !== 'private' || permissionState.admin || incident.user?.id === permissionState.user?.id

const loadIncidents = async () => {
  loading.value = true
  const response = await list(page.value, order.value, search.value, amount.value)
  incidents.value = response?.incidents || []
  total.value = response?.total || 0
  loading.value = false
}

const updateHandler = newPage => { page.value = newPage; loadIncidents() }
const searchIncidents = () => { page.value = 1; loadIncidents() }
const changeFilters = () => { page.value = 1; loadIncidents() }
const formatDate = date => date ? new Date(`${date}T00:00:00`).toLocaleDateString('pt-BR') : '-'

onMounted(loadIncidents)
</script>

<template>
  <div class="min-h-screen flex flex-col overflow-x-hidden">
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center">
      <div class="flex items-center"><img src="/logo_ifms.png" width="160"></div>
      <div class="text-sm">SIGOE - Controle de ocorrências escolares - <span class="text-green-600">Sair</span></div>
    </header>
    <div class="flex flex-col md:flex-row flex-1 min-w-0">
      <Sidebar :activePage="'ocorrencias'" />
      <main class="flex-1 min-w-0 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <h1 class="text-2xl font-bold mb-6">Ocorrências Escolares</h1>
        <div class="bg-white rounded-md shadow p-4 mb-6">
          <div class="flex flex-wrap gap-2"><Button :disabled="!can('occurrences', 'create')"
              customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500" to="/ocorrencias/ocorrencias/novo"><i
                class="fa-solid fa-user"></i>Nova Ocorrência</Button>
            <div class="flex items-center gap-2 ml-auto"><span class="text-sm">Ordenar por</span><select v-model="order"
                @change="changeFilters"
                class="block w-[180px] px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm">
                <option value="id">ID</option>
                <option value="date_incident">Data</option>
              </select></div>
            <div class="flex items-center gap-2"><span class="text-sm">Total</span><select v-model="amount"
                @change="changeFilters"
                class="block w-[80px] px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm">
                <option :value="10">10</option>
                <option :value="25">25</option>
                <option :value="50">50</option>
                <option :value="100">100</option>
              </select></div>
            <div class="flex items-center gap-2"><Input v-model="search" type="text" placeholder="Buscar..."
                class="w-[200px]" /><Button @click="searchIncidents"
                customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500"><i
                  class="fa-solid fa-magnifying-glass"></i>Busca</Button></div>
          </div>
        </div>
        <div class="bg-white rounded-md shadow overflow-hidden w-full">
          <div v-if="loading" class="p-6 text-center">Carregando ocorrências...</div>
          <table v-else class="w-full table-fixed divide-y divide-gray-200">
            <thead class="bg-gray-100">
              <tr>
                <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase">ID</th>
                <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase">Data</th>
                <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase">Estudante</th>
                <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase">Curso</th>
                <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase">Campus</th>
                <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase">Visibilidade</th>
                <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase">Verificado?</th>
                <th class="px-3 py-3 text-left text-xs font-medium text-gray-500 uppercase">Ações</th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="incident in incidents" :key="incident.id">
                <td class="px-3 py-4 text-sm">{{ incident.id }}</td>
                <td class="px-3 py-4 text-sm">{{ formatDate(incident.date_incident) }}</td>
                <td class="px-3 py-4 text-sm">{{ incident.student?.name || '-' }}</td>
                <td class="px-3 py-4 text-sm">{{ incident.course?.name || '-' }}</td>
                <td class="px-3 py-4 text-sm">{{ incident.course?.polo?.name || '-' }}</td>
                <td class="px-3 py-4 text-center text-sm">
                  <i v-if="incident.visibility === 'public'" class="fa-solid fa-check text-green-600" title="Público"></i>
                  <i v-else-if="incident.visibility === 'private'" class="fa-solid fa-lock text-red-600" title="Privado"></i>
                  <span v-else>-</span>
                </td>
                <td class="px-3 py-4 text-center text-sm">
                  <i v-if="incident.signed_in" class="fa-solid fa-check text-green-600"></i>
                  <i v-else class="fa-solid fa-xmark text-red-600"></i>
                </td>
                <td class="px-3 py-4 text-sm"><Button :disabled="!can('occurrences', 'read') || !canAccessIncident(incident)"
                    customClass="w-full bg-green-600 hover:bg-green-700 focus:ring-green-500"
                    :to="`/ocorrencias/ocorrencias/visualizar/${incident.id}`"><i
                      class="fa-solid fa-eye"></i>Visualizar</Button></td>
              </tr>
              <tr v-if="!incidents.length">
                <td colspan="8" class="px-6 py-4 text-center text-sm text-gray-500">Nenhuma ocorrência encontrada.</td>
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
