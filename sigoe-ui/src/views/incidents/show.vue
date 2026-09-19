<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Swal from 'sweetalert2'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Header from '@/components/header.vue'
import { formatDate } from '@/utils'
import { can } from '@/services/permissions'
import { find, remove } from '@/services/incidents'

const route = useRoute()
const router = useRouter()
const incidentId = route.params.id
const loading = ref(true)
const error = ref('')
const incident = ref(null)
const breadcrumbItems = [{ label: 'Home', href: '/' }, { label: 'Ocorrências', href: '/ocorrencias' }, { label: 'Ocorrências', href: '/ocorrencias/ocorrencias/listar' }, { label: 'Visualizar', href: `/ocorrencias/ocorrencias/visualizar/${incidentId}` }]

const loadIncident = async () => {
  try {
    const response = await find(incidentId)
    incident.value = response.incident
  } catch (exception) {
    error.value = 'Não foi possível carregar a ocorrência.'
  } finally {
    loading.value = false
  }
}

const deleteIncident = async () => {
  const confirmation = await Swal.fire({ title: 'Excluir ocorrência?', text: 'Essa ação não poderá ser desfeita.', icon: 'warning', showCancelButton: true, confirmButtonText: 'Sim, excluir', cancelButtonText: 'Cancelar' })
  if (!confirmation.isConfirmed) return
  const response = await remove(incidentId)
  if (response.error) return Swal.fire('Erro', Array.isArray(response.error) ? response.error.join(', ') : response.error, 'error')
  await Swal.fire('Excluída', 'Ocorrência excluída com sucesso.', 'success')
  router.push('/ocorrencias/ocorrencias/listar')
}

onMounted(loadIncident)
</script>

<template>
  <div class="min-h-screen flex flex-col"><Header /><div class="flex flex-col md:flex-row flex-1"><Sidebar :activePage="'ocorrencias'" /><main class="flex-1 p-6"><Breadcrumb :items="breadcrumbItems" /><div v-if="loading">Carregando ocorrência...</div><div v-else-if="error" class="text-red-600">{{ error }}</div><template v-else><h1 class="text-2xl font-bold mb-6">Detalhes da Ocorrência #{{ incident.id }}</h1><div class="grid grid-cols-4 gap-4"><Card customClass="col-span-1" title="Estudante"><div class="flex flex-col items-center gap-2"><img :src="incident.student?.photo || '/placeholder.svg?height=200&width=200'" class="h-40 w-40 object-cover rounded-full" alt="Foto do estudante"><h3 class="font-medium">{{ incident.student?.name }}</h3><p class="text-sm text-gray-500">R.A.: {{ incident.student?.ra }}</p><p class="text-sm text-gray-500">{{ incident.course?.name }}</p><p class="text-sm text-gray-500">Campus: {{ incident.course?.polo?.name || 'Não informado' }}</p></div></Card><Card customClass="col-span-3" title="Informações da Ocorrência"><dl><div v-for="item in [{ label: 'Data', value: formatDate(incident.date_incident) }, { label: 'Horário', value: incident.time_incident }, { label: 'Tipo', value: incident.type_incident?.name }, { label: 'Acesso', value: incident.visibility }, { label: 'Assistente', value: incident.assistant?.name }, { label: 'Encaminhado para', value: incident.sector_id || 'Não encaminhado' }]" :key="item.label" class="py-3 grid grid-cols-3"><dt class="font-medium text-gray-500">{{ item.label }}</dt><dd class="col-span-2">{{ item.value }}</dd></div></dl></Card><Card customClass="col-span-4" title="Descrição da Ocorrência"><p class="whitespace-pre-wrap">{{ incident.description }}</p></Card><Card customClass="col-span-2" title="Capítulo III - Direitos e Deveres"><ul class="space-y-2"><li v-for="item in incident.student_duties" :key="item.id">✓ {{ item.item }}</li><li v-if="!incident.student_duties?.length">Nenhum item selecionado.</li></ul></Card><Card customClass="col-span-2" title="Capítulo IV - Proibições"><ul class="space-y-2"><li v-for="item in incident.prohibition_and_responsibilities" :key="item.id">✓ {{ item.item }}</li><li v-if="!incident.prohibition_and_responsibilities?.length">Nenhum item selecionado.</li></ul></Card><Card customClass="col-span-4" title="Descrição da Solução"><p class="whitespace-pre-wrap">{{ incident.soluction || 'Nenhuma solução descrita ainda.' }}</p></Card><Card customClass="col-span-4" title="Ações"><div class="flex gap-2"><Button v-if="can('occurrences', 'update')" :to="`/ocorrencias/ocorrencias/editar/${incidentId}`">Editar</Button><Button v-if="can('occurrences', 'destroy')" customClass="bg-red-600 hover:bg-red-700" @click="deleteIncident">Excluir</Button></div></Card></div></template></main></div></div>
</template>
