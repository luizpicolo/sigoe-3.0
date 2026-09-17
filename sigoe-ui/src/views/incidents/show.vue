<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Header from '@/components/header.vue'

import { formatDate } from '@/utils'

const route = useRoute()
const incidentId = ref(route.params.id)

const breadcrumbItems = [
  { label: "Home", href: "/" },
  { label: "Ocorrências", href: "/ocorrencias" },
  { label: "Ocorrências", href: "/ocorrencias/ocorrencias/listar" },
  { label: "Visualizar", href: "/ocorrencias/ocorrencias/visualizar" },
];


const incident = ref({
  id: 1,
  date: "2025-05-30",
  time: "21:47",
  student: {
    name: "Luiz Fernando Picolo",
    course: "Curso Técnico em Informática",
    class: "20251301201A",
    campus: "Nova Andradina",
    avatar: "/placeholder.svg?height=200&width=200"
  },
  assistant: {
    name: "Luiz Picolo",
    email: "luiz.picolo@ifms.edu.br"
  },
  forwardedTo: "Coordenação Pedagógica",
  occurrenceType: "Disciplinar",
  accessType: "Público",
  description: "Estudante chegou atrasado na aula e interrompeu a explicação do professor. Demonstrou comportamento inadequado ao questionar a autoridade do docente de forma desrespeitosa.",
  appliedSanction: "Advertência verbal",
  isResolved: true,
  solution: "Foi realizada uma conversa com o estudante sobre a importância do respeito às normas da instituição e aos professores. O estudante demonstrou compreensão e se comprometeu a melhorar seu comportamento.",
  visibility: true,
  verified: true,
  created_at: "2025-05-30T21:47:00Z",
  updated_at: "2025-05-30T22:15:00Z",
  regulations: {
    chapter3: [
      { id: 1, text: "I - ser assíduo e pontual em suas atividades acadêmicas", checked: true },
      { id: 2, text: "II - participar efetiva e atentamente das aulas", checked: false }
    ],
    chapter4: [
      { id: 1, text: "I - proceder de forma desrespeitosa", checked: true },
      { id: 2, text: "II - interromper atividades de ensino sem autorização", checked: true }
    ]
  }
})

onMounted(() => {
  // fetchIncident(incidentId)
})

// const fetchIncident = async (incidentId) => {
//   const response = await find(incidentId)
//   incident.value = response.incident
// }
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <!-- Sidebar -->
      <Sidebar :activePage="'ocorrencias'" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-1">Detalhes da Ocorrência #{{ incident.id }}</h1>

        <div class="flex justify-end">
          <Button to="/ocorrencias/ocorrencias/listar" customClass="bg-white border-gray-200 !text-gray-900 hover:bg-gray-100 !focus:ring-gray-300">
            <i class="fa-solid fa-arrow-left"></i>
            Voltar
          </Button>
        </div>

        <div class="grid grid-cols-4 gap-4 mb-6 mt-4 rounded-lg shadow-sm">
          <!-- Student Photo -->
          <Card customClass="col-span-1" title="Estudante">
            <div class="flex justify-center items-center mt-5 pt-2 pb-5">
              <img :src="incident.student.avatar" width="200" alt="Foto do estudante" />
            </div>
            <div class="text-center">
              <h3 class="font-medium text-gray-900">{{ incident.student.name }}</h3>
              <p class="text-sm text-gray-500">{{ incident.student.course }}</p>
              <p class="text-sm text-gray-500">Turma: {{ incident.student.class }}</p>
            </div>
          </Card>

          <!-- Incident Information -->
          <Card customClass="col-span-3" title="Informações da Ocorrência">
            <dl class="divide-y divide-gray-200">
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Data da ocorrência</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ formatDate(incident.date) }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Horário</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ incident.time }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Campus</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ incident.student.campus }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Tipo de ocorrência</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ incident.occurrenceType }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Tipo de acesso</dt>
                <dd class="text-sm text-gray-900 col-span-2">
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                        :class="incident.accessType === 'Público' ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'">
                    {{ incident.accessType }}
                  </span>
                </dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Assistente responsável</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ incident.assistant.name }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Encaminhado para</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ incident.forwardedTo || 'Não encaminhado' }}</dd>
              </div>
            </dl>
          </Card>

          <!-- Actions -->
          <Card customClass="col-span-1" title="Ações">
            <Button customClass="mt-4 w-full bg-blue-600 hover:bg-blue-700 focus:ring-blue-500" to="/ocorrencias/ocorrencias/editar/1">
              <i class="fa-solid fa-edit"></i>
              Editar Ocorrência
            </Button>
            <Button to="/ocorrencias/relatorio" customClass="mt-4 w-full bg-green-600 hover:bg-green-700 focus:ring-green-500">
              <i class="fa-solid fa-print"></i>
              Imprimir Relatório
            </Button>
            <Button customClass="mt-4 w-full bg-red-600 hover:bg-red-700 focus:ring-red-500">
              <i class="fa-solid fa-trash-alt"></i>
              Excluir Ocorrência
            </Button>
          </Card>

          <!-- Status Information -->
          <Card customClass="col-span-3" title="Status da Ocorrência">
            <dl class="divide-y divide-gray-200">
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Sanção aplicada</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ incident.appliedSanction || 'Nenhuma sanção aplicada' }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Ocorrência resolvida</dt>
                <dd class="text-sm text-gray-900 col-span-2">
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                        :class="incident.isResolved ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'">
                    {{ incident.isResolved ? 'Sim' : 'Não' }}
                  </span>
                </dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Visibilidade</dt>
                <dd class="text-sm text-gray-900 col-span-2">
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                        :class="incident.visibility ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'">
                    {{ incident.visibility ? 'Visível' : 'Oculta' }}
                  </span>
                </dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Verificada</dt>
                <dd class="text-sm text-gray-900 col-span-2">
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                        :class="incident.verified ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'">
                    {{ incident.verified ? 'Verificada' : 'Pendente' }}
                  </span>
                </dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Data de criação</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ formatDate(incident.created_at) }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Última atualização</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ formatDate(incident.updated_at) }}</dd>
              </div>
            </dl>
          </Card>

          <!-- Occurrence Description -->
          <Card customClass="col-span-4" title="Descrição da Ocorrência">
            <div class="bg-gray-50 p-4 rounded-md">
              <p class="text-sm text-gray-700 whitespace-pre-wrap">{{ incident.description }}</p>
            </div>
          </Card>

          <!-- Regulations Chapter 3 -->
          <Card customClass="col-span-2" title="Capítulo III - Direitos e Deveres">
            <div class="space-y-2">
              <div v-for="regulation in incident.regulations.chapter3" :key="regulation.id" class="flex items-start">
                <i :class="regulation.checked ? 'fa-solid fa-check-circle text-green-600' : 'fa-solid fa-circle text-gray-300'" class="mt-1 mr-2"></i>
                <span class="text-sm" :class="regulation.checked ? 'text-gray-900' : 'text-gray-400'">{{ regulation.text }}</span>
              </div>
            </div>
          </Card>

          <!-- Regulations Chapter 4 -->
          <Card customClass="col-span-2" title="Capítulo IV - Proibições">
            <div class="space-y-2">
              <div v-for="regulation in incident.regulations.chapter4" :key="regulation.id" class="flex items-start">
                <i :class="regulation.checked ? 'fa-solid fa-check-circle text-red-600' : 'fa-solid fa-circle text-gray-300'" class="mt-1 mr-2"></i>
                <span class="text-sm" :class="regulation.checked ? 'text-gray-900' : 'text-gray-400'">{{ regulation.text }}</span>
              </div>
            </div>
          </Card>

          <!-- Solution Description -->
          <Card customClass="col-span-4" title="Descrição da Solução">
            <div class="bg-gray-50 p-4 rounded-md">
              <p class="text-sm text-gray-700 whitespace-pre-wrap">{{ incident.solution || 'Nenhuma solução descrita ainda.' }}</p>
            </div>
          </Card>
        </div>
      </main>
    </div>
  </div>
</template>
