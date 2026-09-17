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

const route = useRoute()
const incidentId = ref(route.params.id)
const breadcrumbItems = [{ label: "Home", href: "/" }, { label: "Ocorrências", href: "/ocorrencias" }, { label: "Ocorrências", href: "/ocorrencias/ocorrencias/listar" }, { label: "Visualizar", href: "/ocorrencias/ocorrencias/visualizar" }]
const incident = ref({
  id: 1, date: "2025-05-30", time: "21:47",
  student: { name: "Luiz Fernando Picolo", course: "Curso Técnico em Informática", class: "20251301201A", campus: "Nova Andradina", avatar: "/placeholder.svg?height=200&width=200" },
  assistant: { name: "Luiz Picolo", email: "luiz.picolo@ifms.edu.br" }, forwardedTo: "Coordenação Pedagógica", occurrenceType: "Disciplinar", accessType: "Público",
  description: "Estudante chegou atrasado na aula e interrompeu a explicação do professor.", appliedSanction: "Advertência verbal", isResolved: true,
  solution: "Foi realizada uma conversa com o estudante.", visibility: true, verified: true, created_at: "2025-05-30T21:47:00Z", updated_at: "2025-05-30T22:15:00Z",
  regulations: { chapter3: [{ id: 1, text: "I - ser assíduo e pontual em suas atividades acadêmicas", checked: true }], chapter4: [{ id: 1, text: "I - proceder de forma desrespeitosa", checked: true }] }
})
onMounted(() => {})
</script>

<template>
  <div class="min-h-screen flex flex-col"><Header /><div class="flex flex-col md:flex-row flex-1"><Sidebar :activePage="'ocorrencias'" /><main class="flex-1 p-6">
    <Breadcrumb :items="breadcrumbItems" /><h1 class="text-2xl font-bold mb-1">Detalhes da Ocorrência #{{ incident.id }}</h1>
    <div class="flex justify-end"><Button to="/ocorrencias/ocorrencias/listar" customClass="bg-white border-gray-200 !text-gray-900"><i class="fa-solid fa-arrow-left"></i>Voltar</Button></div>
    <div class="grid grid-cols-4 gap-4 mb-6 mt-4 rounded-lg shadow-sm">
      <Card customClass="col-span-1" title="Estudante"><div class="flex justify-center items-center mt-5 pt-2 pb-5"><img :src="incident.student.avatar" width="200" alt="Foto do estudante" /></div><div class="text-center"><h3 class="font-medium text-gray-900">{{ incident.student.name }}</h3><p class="text-sm text-gray-500">{{ incident.student.course }}</p><p class="text-sm text-gray-500">Turma: {{ incident.student.class }}</p></div></Card>
      <Card customClass="col-span-3" title="Informações da Ocorrência"><dl class="divide-y divide-gray-200"><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Data da ocorrência</dt><dd class="text-sm text-gray-900 col-span-2">{{ formatDate(incident.date) }}</dd></div><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Horário</dt><dd class="text-sm text-gray-900 col-span-2">{{ incident.time }}</dd></div><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Campus</dt><dd class="text-sm text-gray-900 col-span-2">{{ incident.student.campus }}</dd></div><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Tipo de ocorrência</dt><dd class="text-sm text-gray-900 col-span-2">{{ incident.occurrenceType }}</dd></div><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Tipo de acesso</dt><dd class="text-sm text-gray-900 col-span-2">{{ incident.accessType }}</dd></div><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Assistente responsável</dt><dd class="text-sm text-gray-900 col-span-2">{{ incident.assistant.name }}</dd></div><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Encaminhado para</dt><dd class="text-sm text-gray-900 col-span-2">{{ incident.forwardedTo || 'Não encaminhado' }}</dd></div></dl></Card>
      <Card customClass="col-span-1" title="Ações"><Button v-if="can('occurrences', 'update')" customClass="mt-4 w-full bg-blue-600 hover:bg-blue-700" :to="`/ocorrencias/ocorrencias/editar/${incidentId}`"><i class="fa-solid fa-edit"></i>Editar Ocorrência</Button><Button v-if="can('occurrences', 'read')" to="/ocorrencias/relatorio" customClass="mt-4 w-full bg-green-600 hover:bg-green-700"><i class="fa-solid fa-print"></i>Imprimir Relatório</Button><Button v-if="can('occurrences', 'destroy')" customClass="mt-4 w-full bg-red-600 hover:bg-red-700"><i class="fa-solid fa-trash-alt"></i>Excluir Ocorrência</Button></Card>
      <Card customClass="col-span-3" title="Status da Ocorrência"><dl class="divide-y divide-gray-200"><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Sanção aplicada</dt><dd class="text-sm text-gray-900 col-span-2">{{ incident.appliedSanction || 'Nenhuma sanção aplicada' }}</dd></div><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Ocorrência resolvida</dt><dd class="text-sm text-gray-900 col-span-2">{{ incident.isResolved ? 'Sim' : 'Não' }}</dd></div><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Visibilidade</dt><dd class="text-sm text-gray-900 col-span-2">{{ incident.visibility ? 'Visível' : 'Oculta' }}</dd></div><div class="py-3 grid grid-cols-3"><dt class="text-sm font-medium text-gray-500">Verificada</dt><dd class="text-sm text-gray-900 col-span-2">{{ incident.verified ? 'Verificada' : 'Pendente' }}</dd></div></dl></Card>
      <Card customClass="col-span-4" title="Descrição da Ocorrência"><div class="bg-gray-50 p-4 rounded-md"><p class="text-sm text-gray-700 whitespace-pre-wrap">{{ incident.description }}</p></div></Card>
      <Card customClass="col-span-2" title="Capítulo III - Direitos e Deveres"><div class="space-y-2"><div v-for="regulation in incident.regulations.chapter3" :key="regulation.id" class="flex items-start"><i :class="regulation.checked ? 'fa-solid fa-check-circle text-green-600' : 'fa-solid fa-circle text-gray-300'" class="mt-1 mr-2"></i><span class="text-sm">{{ regulation.text }}</span></div></div></Card>
      <Card customClass="col-span-2" title="Capítulo IV - Proibições"><div class="space-y-2"><div v-for="regulation in incident.regulations.chapter4" :key="regulation.id" class="flex items-start"><i :class="regulation.checked ? 'fa-solid fa-check-circle text-red-600' : 'fa-solid fa-circle text-gray-300'" class="mt-1 mr-2"></i><span class="text-sm">{{ regulation.text }}</span></div></div></Card>
      <Card customClass="col-span-4" title="Descrição da Solução"><div class="bg-gray-50 p-4 rounded-md"><p class="text-sm text-gray-700 whitespace-pre-wrap">{{ incident.solution || 'Nenhuma solução descrita ainda.' }}</p></div></Card>
    </div>
  </main></div></div>
</template>
