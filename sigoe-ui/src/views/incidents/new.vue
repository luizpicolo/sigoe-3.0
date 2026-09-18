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
const errorMessage = ref('')
const successMessage = ref('')

const filteredStudents = computed(() => {
  const search = studentSearch.value.toLowerCase().trim()
  if (!search) return students.value
  return students.value.filter(student => `${student.name} ${student.ra || ''}`.toLowerCase().includes(search))
})

const loadStudents = async () => {
  const response = await listStudents(1, 'name', null, 1000)
  students.value = response?.students || []
}

const handleSubmit = async () => {
  errorMessage.value = ''
  successMessage.value = ''
  if (!selectedStudentIds.value.length) {
    errorMessage.value = 'Selecione pelo menos um estudante.'
    return
  }
  loading.value = true
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
  loading.value = false
  if (response?.error) {
    errorMessage.value = Array.isArray(response.error) ? response.error.join(', ') : response.error
    return
  }
  successMessage.value = 'Ocorrência cadastrada para os estudantes selecionados.'
}

onMounted(loadStudents)
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center">
      <img src="/logo_ifms.png" width="160">
      <div class="text-sm">SIGOE - Controle de ocorrências escolares - <span class="text-green-600">Sair</span></div>
    </header>
    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'ocorrencias'" />
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <h1 class="text-2xl font-bold mb-6">Cadastrar Nova Ocorrência</h1>
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <Card customClass="mb-4" title="Estudantes">
            <label class="block text-sm font-medium text-gray-700 mb-1">Pesquisar estudantes</label>
            <input v-model="studentSearch" type="search" placeholder="Nome ou R.A." class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm mb-3">
            <label class="block text-sm font-medium text-gray-700 mb-1">Selecione um ou mais estudantes</label>
            <select v-model="selectedStudentIds" multiple size="8" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm">
              <option v-for="student in filteredStudents" :key="student.id" :value="student.id">{{ student.name }}{{ student.ra ? ` - ${student.ra}` : '' }}</option>
            </select>
            <p class="text-sm text-gray-600 mt-2">{{ selectedStudentIds.length }} estudante(s) selecionado(s)</p>
            <Select id="studentType" name="studentType" label="Estudante é?" v-model="selectedStudentType" :options="[{ value: 'non_resident', label: 'Não residente' }, { value: 'resident', label: 'Residente' }]" />
          </Card>
          <Card customClass="mb-4" title="Assistente">
            <label class="block text-sm font-medium text-gray-700 mb-1">ID do assistente</label>
            <Input v-model="selectedAssistant" type="number" placeholder="ID do usuário assistente" />
          </Card>
          <Card customClass="mb-4" title="Ocorrência">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
              <Input v-model="dateIncident" type="date" placeholder="Data ocorrência" />
              <Input v-model="timeIncident" type="time" placeholder="Hora ocorrência" />
              <Input v-model="selectedOccurrenceType" type="number" placeholder="ID do tipo de ocorrência" />
              <Select id="accessType" name="accessType" label="Tipo de acesso" v-model="selectedAccessType" :options="[{ value: 'public', label: 'Público' }, { value: 'private', label: 'Privado' }]" />
            </div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Descrição</label>
            <textarea v-model="description" rows="6" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm mb-4"></textarea>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <Input v-model="selectedSanction" placeholder="Sanção aplicada" />
              <Select id="resolved" name="resolved" label="Ocorrência resolvida?" v-model="occurrenceResolved" :options="[{ value: 'no_', label: 'Não' }, { value: 'yes_', label: 'Sim' }]" />
            </div>
          </Card>
          <Card customClass="mb-4" title="Solução">
            <textarea v-model="solution" rows="6" placeholder="Descrição da solução" class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm"></textarea>
          </Card>
          <p v-if="errorMessage" class="text-red-600">{{ errorMessage }}</p>
          <p v-if="successMessage" class="text-green-600">{{ successMessage }}</p>
          <Button type="submit" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500" :disabled="loading">{{ loading ? 'Salvando...' : 'Salvar' }}</Button>
        </form>
      </main>
    </div>
  </div>
</template>
