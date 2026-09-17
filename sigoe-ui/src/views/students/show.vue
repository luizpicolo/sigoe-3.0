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
const studentId = ref(route.params.id)

const breadcrumbItems = [
  { label: "Home", href: "/" },
  { label: "Administrador", href: "/administrador" },
  { label: "Estudantes", href: "/administrador/estudantes/listar" },
  { label: "Visualizar", href: `/administrador/estudantes/visualizar/${studentId.value}` },
];

const student = ref({
  id: studentId.value,
  name: "NAIANY GOMES DA SILVA",
  cpf: "080.184.921-74",
  birthdate: "2011-01-17",
  registration: "IF2023001245",
  status: "Ativo",
  course: "Curso Técnico em Informática",
  class: "20251301201A",
  campus: "Nova Andradina",
  responsible: "Maria da Silva",
  contact: "maria.silva@email.com / (67) 99999-8888",
  address: "Rua das Flores, 123 - Centro, Nova Andradina - MS",
  avatar: "/placeholder.svg?height=200&width=200",
  created_at: "2023-02-15T10:30:00Z",
  updated_at: "2025-05-30T14:45:00Z",
  attendance: {
    present: 85,
    absent: 15,
    total: 100
  },
  grades: {
    average: 8.5,
    status: "Aprovado"
  },
  occurrences: [
    { id: 1, date: "2025-04-15T08:30:00Z", type: "Disciplinar", description: "Atraso na aula" },
    { id: 2, date: "2025-05-10T09:45:00Z", type: "Acadêmica", description: "Não entrega de atividade" }
  ]
})

onMounted(() => {
  // fetchStudent(studentId.value)
})

// const fetchStudent = async (id) => {
//   try {
//     const response = await findStudent(id)
//     student.value = response.student
//   } catch (error) {
//     console.error('Erro ao buscar dados do estudante:', error)
//   }
// }
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <!-- Sidebar -->
      <Sidebar :activePage="'estudantes'" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-1">Detalhes do Estudante</h1>

        <div class="flex justify-end">
          <Button to="/administrador/estudantes/listar" customClass="bg-white border-gray-200 !text-gray-900 hover:bg-gray-100 !focus:ring-gray-300">
            <i class="fa-solid fa-arrow-left"></i>
            Voltar
          </Button>
        </div>

        <div class="grid grid-cols-4 gap-4 mb-6 mt-4 rounded-lg shadow-sm">
          <!-- Student Photo -->
          <Card customClass="col-span-1" title="Foto">
            <div class="flex justify-center items-center mt-5 pt-2 pb-5">
              <img :src="student.avatar" width="200" alt="Foto do estudante" class="rounded-md" />
            </div>
          </Card>

          <!-- Personal Information -->
          <Card customClass="col-span-3" title="Informações Pessoais">
            <dl class="divide-y divide-gray-200">
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Nome completo</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ student.name }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">CPF</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ student.cpf }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Data de Nascimento</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ formatDate(student.birthdate) }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Responsável</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ student.responsible }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Contato</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ student.contact }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Endereço</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ student.address }}</dd>
              </div>
            </dl>
          </Card>

          <!-- Actions -->
          <Card customClass="col-span-1" title="Ações">
            <Button variant="info" :to="`/administrador/estudantes/editar/${student.id}`">
              <i class="fa-solid fa-edit"></i>
              Editar Estudante
            </Button>
            <Button customClass="mt-4 w-full bg-green-600 hover:bg-green-700 focus:ring-green-500">
              <i class="fa-solid fa-print"></i>
              Imprimir Ficha
            </Button>
            <Button customClass="mt-4 w-full bg-yellow-600 hover:bg-yellow-700 focus:ring-yellow-500">
              <i class="fa-solid fa-file-alt"></i>
              Histórico Escolar
            </Button>
            <Button customClass="mt-4 w-full bg-red-600 hover:bg-red-700 focus:ring-red-500">
              <i class="fa-solid fa-trash-alt"></i>
              Excluir Estudante
            </Button>
          </Card>

          <!-- Academic Information -->
          <Card customClass="col-span-3" title="Informações Acadêmicas">
            <dl class="divide-y divide-gray-200">
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Matrícula</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ student.registration }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Status</dt>
                <dd class="text-sm text-gray-900 col-span-2">
                  <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                    {{ student.status }}
                  </span>
                </dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Curso</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ student.course }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Turma</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ student.class }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Campus</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ student.campus }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Data de cadastro</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ formatDate(student.created_at) }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Última atualização</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ formatDate(student.updated_at) }}</dd>
              </div>
            </dl>
          </Card>

          <!-- Academic Performance -->
          <Card customClass="col-span-2" title="Desempenho Acadêmico">
            <div class="mb-4">
              <h3 class="text-sm font-medium text-gray-700 mb-2">Frequência</h3>
              <div class="bg-gray-100 rounded-full h-4 overflow-hidden">
                <div class="bg-green-600 h-4" :style="`width: ${student.attendance.present}%`"></div>
              </div>
              <div class="flex justify-between text-xs mt-1">
                <span>Presente: {{ student.attendance.present }}%</span>
                <span>Ausente: {{ student.attendance.absent }}%</span>
              </div>
            </div>

            <div>
              <h3 class="text-sm font-medium text-gray-700 mb-2">Média Geral</h3>
              <div class="flex items-center">
                <div class="text-2xl font-bold mr-3">{{ student.grades.average }}</div>
                <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                      :class="student.grades.status === 'Aprovado' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'">
                  {{ student.grades.status }}
                </span>
              </div>
            </div>
          </Card>

          <!-- Recent Occurrences -->
          <Card customClass="col-span-2" title="Ocorrências Recentes">
            <div v-if="student.occurrences.length > 0">
              <div v-for="occurrence in student.occurrences" :key="occurrence.id" class="mb-3 pb-3 border-b border-gray-100 last:border-0">
                <div class="flex justify-between items-start">
                  <div>
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium mb-1"
                          :class="occurrence.type === 'Disciplinar' ? 'bg-yellow-100 text-yellow-800' : 'bg-blue-100 text-blue-800'">
                      {{ occurrence.type }}
                    </span>
                    <p class="text-sm text-gray-900">{{ occurrence.description }}</p>
                  </div>
                  <span class="text-xs text-gray-500">{{ formatDate(occurrence.date) }}</span>
                </div>
              </div>
            </div>
            <div v-else class="text-sm text-gray-500 py-2">
              Nenhuma ocorrência registrada.
            </div>
            <div class="mt-3 text-right">
              <Button to="/ocorrencias/ocorrencias/listar" customClass="text-sm bg-white border-gray-200 !text-gray-700 hover:bg-gray-50 !focus:ring-gray-300">
                Ver todas
              </Button>
            </div>
          </Card>
        </div>
      </main>
    </div>
  </div>
</template>
