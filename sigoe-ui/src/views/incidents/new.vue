<script setup>
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Input from '@/components/ui/input.vue'
import Card from '@/components/ui/card.vue'
import Select from '@/components/ui/select.vue'
import { computed, onMounted, ref } from 'vue'
import { list as listStudents } from '@/services/students'
import { create as createIncident } from '@/services/incidents'

const breadcrumbItems = [
  { label: 'Home', href: '/' },
  { label: 'Administrador', href: '/' },
  { label: 'Ocorrências', href: '/ocorrencias/ocorrencias/listar' },
  { label: 'Nova', href: '/ocorrencias/ocorrencias/nova' }
]

const students = ref([])
const studentSearch = ref('')
const selectedStudentIds = ref([])
const selectedStudentType = ref('non_resident')
const selectedAssistant = ref('')
const selectedOccurrenceType = ref('')
const selectedAccessType = ref('public')
const selectedSanction = ref('')
const occurrenceResolved = ref('no_')
const dateIncident = ref('')
const timeIncident = ref('')
const description = ref('')
const solution = ref('')
const loading = ref(false)
const loadingStudents = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const filteredStudents = computed(() => {
  const search = studentSearch.value.toLowerCase().trim()
  if (!search) return students.value
  return students.value.filter(student => `${student.name || ''} ${student.ra || ''} ${student.enrollment || ''}`.toLowerCase().includes(search))
})

const toggleStudent = (studentId) => {
  if (selectedStudentIds.value.includes(studentId)) {
    selectedStudentIds.value = selectedStudentIds.value.filter(id => id !== studentId)
  } else {
    selectedStudentIds.value = [...selectedStudentIds.value, studentId]
  }
}

const isStudentSelected = (studentId) => selectedStudentIds.value.includes(studentId)

const loadStudents = async () => {
  loadingStudents.value = true
  const allStudents = []
  let page = 1
  let total = 0
  const amount = 100

  try {
    do {
      const response = await listStudents(page, 'name', null, amount)
      const pageStudents = response?.students || []
      allStudents.push(...pageStudents)
      total = response?.total || allStudents.length
      page += 1
      if (!pageStudents.length) break
    } while (allStudents.length < total)

    students.value = allStudents.filter((student, index, collection) => collection.findIndex(item => item.id === student.id) === index)
  } finally {
    loadingStudents.value = false
  }
}

const handleSubmit = async () => {
  errorMessage.value = ''
  successMessage.value = ''
  if (!selectedStudentIds.value.length) {
    errorMessage.value = 'Selecione pelo menos um estudante.'
    return
  }

  loading.value = true
  try {
    const response = await createIncident({
      student_ids: selectedStudentIds.value,
      type_student: selectedStudentType.value,
      assistant_id: selectedAssistant.value,
      type_incident_id: selectedOccurrenceType.value,
      visibility: selectedAccessType.value,
      sanction: selectedSanction.value || null,
      is_resolved: occurrenceResolved.value,
      date_incident: dateIncident.value,
      time_incident: timeIncident.value,
      description: description.value,
      soluction: solution.value
    })

    if (response?.error) {
      errorMessage.value = Array.isArray(response.error) ? response.error.join(', ') : response.error
      return
    }

    successMessage.value = 'Ocorrência cadastrada para os estudantes selecionados.'
  } catch (error) {
    errorMessage.value = error.response?.data?.errors?.join(', ') || 'Não foi possível cadastrar a ocorrência.'
  } finally {
    loading.value = false
  }
}

onMounted(loadStudents)
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center">
      <div class="flex items-center">
        <img src="/logo_ifms.png" width="160">
      </div>
      <div class="text-sm">SIGOE - Controle de ocorrências escolares - <span class="text-green-600">Sair</span></div>
    </header>

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'ocorrencias'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <h1 class="text-2xl font-bold mb-6">Cadastrar Nova Ocorrência</h1>

        <form @submit.prevent="handleSubmit" class="space-y-6">
          <div class="p-1 rounded-lg shadow-sm">
            <Card customClass="mb-4" title="Estudante">
              <div class="grid grid-cols-6 gap-6 mb-6">
                <div class="col-span-4">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Pesquisar estudantes</label>
                  <input v-model="studentSearch" type="search" placeholder="Nome, R.A. ou matrícula" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm mb-3">
                  <div class="border border-gray-300 rounded-md divide-y divide-gray-200 max-h-64 overflow-y-auto">
                    <div v-if="loadingStudents" class="px-3 py-4 text-sm text-gray-500">Carregando estudantes...</div>
                    <label v-for="student in filteredStudents" :key="student.id" class="flex items-center gap-3 px-3 py-2 cursor-pointer hover:bg-gray-50">
                      <input type="checkbox" :checked="isStudentSelected(student.id)" @change="toggleStudent(student.id)" class="h-4 w-4">
                      <span class="text-sm text-gray-700">{{ student.name }}{{ student.ra ? ` - ${student.ra}` : '' }}</span>
                    </label>
                    <div v-if="!loadingStudents && !filteredStudents.length" class="px-3 py-4 text-sm text-gray-500">Nenhum estudante encontrado.</div>
                  </div>
                  <p class="text-sm text-gray-600 mt-2">{{ selectedStudentIds.length }} estudante(s) selecionado(s)</p>
                </div>
                <div class="col-span-2">
                  <Select id="studentType" name="studentType" label="Estudante é?" v-model="selectedStudentType" :options="[{ value: 'non_resident', label: 'Não residente' }, { value: 'resident', label: 'Residente' }]" />
                </div>
              </div>
            </Card>

            <Card customClass="mb-4" title="Assistente">
              <div class="grid grid-cols-6 gap-6 mb-6">
                <div class="col-span-3">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Assistente</label>
                  <Input v-model="selectedAssistant" type="number" placeholder="ID do usuário assistente" />
                </div>
                <div class="col-span-3">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Encaminhar para</label>
                  <Input placeholder="Não enviar notificação" disabled />
                </div>
              </div>
            </Card>

            <Card customClass="mb-4" title="Ocorrência">
              <div class="grid grid-cols-12 gap-4 mb-4">
                <div class="col-span-3"><label class="block text-sm font-medium text-gray-700 mb-1">Data ocorrência</label><Input v-model="dateIncident" type="date" placeholder="30/05/2025" /></div>
                <div class="col-span-3"><label class="block text-sm font-medium text-gray-700 mb-1">Hora ocorrência</label><Input v-model="timeIncident" type="time" placeholder="21:47" /></div>
                <div class="col-span-3"><label class="block text-sm font-medium text-gray-700 mb-1">Tipo da ocorrência</label><Input v-model="selectedOccurrenceType" type="number" placeholder="ID do tipo" /></div>
                <div class="col-span-3"><Select id="accessType" name="accessType" label="Tipo de acesso" v-model="selectedAccessType" :options="[{ value: 'public', label: 'Público' }, { value: 'private', label: 'Privado' }]" /></div>
              </div>
              <div class="mb-4 text-xs text-gray-600 italic"><strong>* Observação:</strong> Ocorrências privadas somente serão visualizadas por quem as criou.</div>
              <div class="mb-4"><label class="block text-sm font-medium text-gray-700 mb-1">Ocorrência</label><textarea v-model="description" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm" rows="6"></textarea></div>
              <div class="grid grid-cols-6 gap-6 mb-4">
                <div class="col-span-3"><label class="block text-sm font-medium text-gray-700 mb-1">Sanção aplicada</label><Input v-model="selectedSanction" placeholder="Sanção aplicada" /></div>
                <div class="col-span-3"><Select id="resolved" name="resolved" label="Ocorrência resolvida?" v-model="occurrenceResolved" :options="[{ value: 'no_', label: 'Não' }, { value: 'yes_', label: 'Sim' }]" /></div>
              </div>
            </Card>

            <Card customClass="mb-4">
              <p class="font-medium">Segundo o Capítulo III, Art. 4º, que trata sobre os direitos e deveres do estudante</p>
              <div class="space-y-2 mb-4 mt-3"><label v-for="item in ['I - ser assíduo e pontual em suas atividades acadêmicas', 'II - participar efetiva e atentamente das aulas', 'III - participar das atividades curriculares e extracurriculares', 'IV - acompanhar as comunicações internas']" :key="item" class="flex items-start"><input type="checkbox" class="mt-1 mr-2"><span class="text-sm">{{ item }}</span></label></div>
            </Card>

            <Card customClass="mb-4">
              <p class="font-medium">Segundo o Capítulo IV, que trata sobre as proibições e responsabilidades</p>
              <div class="space-y-2 mb-4 mt-3"><label v-for="item in ['I - proceder de forma desrespeitosa', 'II - interromper atividades de ensino sem autorização', 'III - utilizar aparelhos eletrônicos sem autorização', 'IV - realizar consulta não autorizada durante avaliações']" :key="item" class="flex items-start"><input type="checkbox" class="mt-1 mr-2"><span class="text-sm">{{ item }}</span></label></div>
            </Card>

            <Card customClass="mb-4">
              <label class="block text-sm font-medium text-gray-700 mb-1">Descrição da solução</label>
              <textarea v-model="solution" rows="6" placeholder="Solução" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm"></textarea>
            </Card>
          </div>

          <p v-if="errorMessage" class="text-red-600">{{ errorMessage }}</p>
          <p v-if="successMessage" class="text-green-600">{{ successMessage }}</p>
          <div class="flex justify-start"><Button type="submit" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500" :disabled="loading">{{ loading ? 'Salvando...' : 'Salvar' }}</Button></div>
        </form>
      </main>
    </div>
  </div>
</template>
