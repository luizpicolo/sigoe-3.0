<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Header from '@/components/header.vue'
import { formatDate } from '@/utils'
import { can } from '@/services/permissions'
import { find } from '@/services/incidents'

const route = useRoute()
const incidentId = ref(route.params.id)
const loading = ref(true)
const error = ref(null)
const incident = ref({ regulations: { chapter3: [], chapter4: [] } })
const breadcrumbItems = [{ label: 'Home', href: '/' }, { label: 'Ocorrências', href: '/ocorrencias' }, { label: 'Ocorrências', href: '/ocorrencias/ocorrencias/listar' }, { label: 'Visualizar', href: '/ocorrencias/ocorrencias/visualizar' }]

const loadIncident = async () => {
  try {
    const response = await find(incidentId.value)
    const data = response.incident
    incident.value = {
      ...data,
      date: data.date || data.date_incident,
      time: data.time || data.time_incident,
      student: { ...data.student, course: data.student?.course?.name || data.course?.name, class: data.student?.school_group?.identifier, campus: data.course?.polo?.name, avatar: data.student?.photo },
      assistant: { name: data.user?.name, email: data.user?.email },
      occurrenceType: data.type_incident?.name,
      accessType: data.visibility ? 'Público' : 'Privado',
      isResolved: data.is_resolved,
      verified: data.signed_in,
      description: data.description,
      solution: data.solution,
      appliedSanction: data.applied_sanction,
      forwardedTo: data.forwarded_to,
      regulations: data.regulations || { chapter3: [], chapter4: [] }
    }
  } catch (exception) {
    error.value = 'Não foi possível carregar a ocorrência.'
  } finally {
    loading.value = false
  }
}

onMounted(loadIncident)
</script>

<template>
  <div class="min-h-screen flex flex-col"><Header /><div class="flex flex-col md:flex-row flex-1"><Sidebar :activePage="'ocorrencias'" /><main class="flex-1 p-6"><Breadcrumb :items="breadcrumbItems" /><div v-if="loading" class="py-8 text-center">Carregando ocorrência...</div><div v-else-if="error" class="py-8 text-center text-red-600">{{ error }}</div><template v-else><h1 class="text-2xl font-bold mb-1">Detalhes da Ocorrência #{{ incident.id }}</h1><div class="flex justify-end"><Button to="/ocorrencias/ocorrencias/listar" customClass="bg-white border-gray-200 !text-gray-900"><i class="fa-solid fa-arrow-left"></i>Voltar</Button></div><div class="grid grid-cols-4 gap-4 mb-6 mt-4 rounded-lg shadow-sm"><Card customClass="col-span-1" title="Estudante"><div class="flex justify-center items-center mt-5 pt-2 pb-5"><img :src="incident.student?.avatar || '/placeholder.svg?height=200&width=200'" width="200" alt="Foto do estudante" /></div><div class="text-center"><h3 class="font-medium text-gray-900">{{ incident.student?.name }}</h3><p class="text-sm text-gray-500">{{ incident.student?.course }}</p><p class="text-sm text-gray-500">Turma: {{ incident.student?.class || 'Não informada' }}</p></div></Card><Card customClass="col-span-3" title="Informações da Ocorrência"><dl class="divide-y divide-gray-200"><div v-for="item in [{ label: 'Data da ocorrência', value: formatDate(incident.date) }, { label: 'Horário', value: incident.time }, { label: 'Campus', value: incident.student?.campus }, { label: 'Tipo de ocorrência', value: incident.occurrenceType }, { label: 'Tipo de acesso', value: incident.accessType }, { label: 'Assistente responsável', value: incident.assistant?.name }, { label: 'Encaminhado para', value: incident.forwardedTo || 'Não encaminhado' }]" :key="item.label" class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">{{ item.label }}</dt><dd class="text-sm text-gray-900 col-span-2">{{ item.value }}</dd></div></dl></Card><Card customClass="col-span-1" title="Ações"><Button v-if="can('occurrences', 'update')" customClass="mt-4 w-full bg-blue-600 hover:bg-blue-700" :to="`/ocorrencias/ocorrencias/editar/${incidentId}`"><i class="fa-solid fa-edit"></i>Editar Ocorrência</Button><Button v-if="can('occurrences', 'read')" to="/ocorrencias/relatorio" customClass="mt-4 w-full bg-green-600 hover:bg-green-700"><i class="fa-solid fa-print"></i>Imprimir Relatório</Button><Button v-if="can('occurrences', 'destroy')" customClass="mt-4 w-full bg-red-600 hover:bg-red-700"><i class="fa-solid fa-trash-alt"></i>Excluir Ocorrência</Button></Card><Card customClass="col-span-3" title="Status da Ocorrência"><dl class="divide-y divide-gray-200"><div v-for="item in [{ label: 'Sanção aplicada', value: incident.appliedSanction || 'Nenhuma sanção aplicada' }, { label: 'Ocorrência resolvida', value: incident.isResolved ? 'Sim' : 'Não' }, { label: 'Visibilidade', value: incident.visibility ? 'Visível' : 'Oculta' }, { label: 'Verificada', value: incident.verified ? 'Verificada' : 'Pendente' }]" :key="item.label" class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">{{ item.label }}</dt><dd class="text-sm text-gray-900 col-span-2">{{ item.value }}</dd></div></dl></Card><Card customClass="col-span-4" title="Descrição da Ocorrência"><div class="bg-gray-50 p-4 rounded-md"><p class="text-sm text-gray-700 whitespace-pre-wrap">{{ incident.description }}</p></div></Card><Card customClass="col-span-2" title="Capítulo III - Direitos e Deveres"><div class="space-y-2"><div v-for="regulation in incident.regulations.chapter3" :key="regulation.id" class="flex items-start"><i :class="regulation.checked ? 'fa-solid fa-check-circle text-green-600' : 'fa-solid fa-circle text-gray-300'" class="mt-1 mr-2"></i><span class="text-sm">{{ regulation.text }}</span></div></div></Card><Card customClass="col-span-2" title="Capítulo IV - Proibições"><div class="space-y-2"><div v-for="regulation in incident.regulations.chapter4" :key="regulation.id" class="flex items-start"><i :class="regulation.checked ? 'fa-solid fa-check-circle text-red-600' : 'fa-solid fa-circle text-gray-300'" class="mt-1 mr-2"></i><span class="text-sm">{{ regulation.text }}</span></div></div></Card><Card customClass="col-span-4" title="Descrição da Solução"><div class="bg-gray-50 p-4 rounded-md"><p class="text-sm text-gray-700 whitespace-pre-wrap">{{ incident.solution || 'Nenhuma solução descrita ainda.' }}</p></div></Card></div></template></main></div></div>
</template>
