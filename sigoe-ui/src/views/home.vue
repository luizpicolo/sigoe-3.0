<script setup>
import { onMounted, ref } from 'vue'
import Sidebar from '@/components/sidebar.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Chart from '@/components/ui/chart.vue'
import Header from '@/components/header.vue'
import { show } from '@/services/dashboard'
import { error } from '@/utils/sweetPopup2'

const breadcrumbItems = [{ label: 'Home', href: '/' }]
const dashboard = ref(null)
const loading = ref(true)

const loadDashboard = async () => {
  try {
    dashboard.value = await show()
  } catch (requestError) {
    error(requestError.response?.data?.error || requestError.response?.data?.errors?.join(', ') || 'Não foi possível carregar os gráficos.')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadDashboard()
})
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="''" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <div class="mb-6 bg-green-50 border border-green-200 rounded-md p-4 flex items-start">
          <svg class="text-green-600 mr-3 mt-0.5 h-5 w-5 flex-shrink-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M12 2a10 10 0 100 20 10 10 0 000-20z" />
          </svg>

          <div>
            <p class="text-green-800">
              Olá prezado(a) servidor(a), seja bem vindo(a) ao SIGOE (Sistema para o controle de ocorrências escolares). Atualmente o sistema não é mantido pela DIRTI. Por este motivo, pedimos a gentileza de entrar em contato com o administrador local. Caso a solicitação seja para solução de problemas ou pedido de novas funcionalidades, entre em contato com o administrador geral luiz.picolo@ifms.edu.br.
            </p>
          </div>
        </div>

        <h1 class="text-2xl font-bold mb-6">
          Dashboard
        </h1>

        <p v-if="loading" class="text-sm text-gray-500">
          Carregando gráficos...
        </p>

        <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <Chart title="Ocorrências por ano" :data="dashboard.by_years" />
          <Chart title="Ocorrências por turma" :data="dashboard.by_courses" />
          <Chart title="Ocorrências por tipo" :data="dashboard.by_type_incident" />
          <Chart title="Sanções adotadas" :data="dashboard.by_sanction" />
          <Chart title="Ocorrências resolvidas" :data="dashboard.by_is_resolved" />
        </div>
      </main>
    </div>
  </div>
</template>