<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import Sidebar from '@/components/sidebar.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Button from '@/components/ui/button.vue'
import Select from '@/components/ui/select.vue'
import Input from '@/components/ui/input.vue'
import Card from '@/components/ui/card.vue'
import { list as listStudents } from '@/services/students'
import { create as createIncident, options as incidentOptions } from '@/services/incidents'

const breadcrumbItems = [{ label: 'Home', href: '/' }, { label: 'Administrador', href: '/' }, { label: 'Ocorrências', href: '/ocorrencias/ocorrencias/listar' }, { label: 'Nova', href: '/ocorrencias/ocorrencias/nova' }]
const students = ref([])
const selectedStudents = ref([])
const studentSearch = ref('')
const options = ref({ assistants: [], sectors: [], type_incidents: [], student_duties: [], prohibition_and_responsibilities: [], sanctions: [] })
const selectedStudentType = ref('non_resident')
const selectedAssistant = ref('')
const selectedSector = ref('')
const selectedOccurrenceType = ref('')
const selectedAccessType = ref('public')
const selectedSanction = ref('')
const occurrenceResolved = ref('no_')
const dateIncident = ref('')
const timeIncident = ref('')
const description = ref('')
const solution = ref('')
const studentDuties = ref([])
const prohibitions = ref([])
const loadingStudents = ref(false)
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')
let searchTimer

const selectedStudentIds = computed(() => selectedStudents.value.map(student => student.id))
const visibleStudents = computed(() => students.value.filter(student => `${student.name || ''} ${student.ra || ''} ${student.enrollment || ''}`.toLowerCase().includes(studentSearch.value.toLowerCase().trim())))
const assistantOptions = computed(() => options.value.assistants.map(item => ({ value: String(item.id), label: `${item.name}${item.email ? ` - ${item.email}` : ''}` })))
const sectorOptions = computed(() => options.value.sectors.map(item => ({ value: String(item.id), label: `${item.name}${item.email ? ` - ${item.email}` : ''}` })))
const occurrenceOptions = computed(() => options.value.type_incidents.map(item => ({ value: String(item.id), label: item.name })))

const searchStudents = async () => {
  loadingStudents.value = true
  try {
    const response = await listStudents(1, 'name', studentSearch.value.trim() || null, 30)
    const results = response?.students || []
    students.value = [...selectedStudents.value, ...results].filter((student, index, list) => list.findIndex(item => item.id === student.id) === index)
  } finally {
    loadingStudents.value = false
  }
}

watch(studentSearch, () => {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(searchStudents, 350)
})

const toggleStudent = student => {
  const exists = selectedStudents.value.some(item => item.id === student.id)
  selectedStudents.value = exists ? selectedStudents.value.filter(item => item.id !== student.id) : [...selectedStudents.value, student]
}

const isSelected = id => selectedStudentIds.value.includes(id)

const handleSubmit = async () => {
  errorMessage.value = ''
  successMessage.value = ''
  if (!selectedStudentIds.value.length) return (errorMessage.value = 'Selecione pelo menos um estudante.')
  loading.value = true
  try {
    const response = await createIncident({ student_ids: selectedStudentIds.value, type_student: selectedStudentType.value, assistant_id: selectedAssistant.value, sector_id: selectedSector.value || null, type_incident_id: selectedOccurrenceType.value, visibility: selectedAccessType.value, sanction: selectedSanction.value || null, is_resolved: occurrenceResolved.value, date_incident: dateIncident.value, time_incident: timeIncident.value, description: description.value, soluction: solution.value, student_duty_ids: studentDuties.value, prohibition_and_responsibility_ids: prohibitions.value })
    if (response.error) errorMessage.value = Array.isArray(response.error) ? response.error.join(', ') : response.error
    else successMessage.value = 'Ocorrência cadastrada para os estudantes selecionados.'
  } catch (error) {
    errorMessage.value = error.response?.data?.errors?.join(', ') || 'Não foi possível cadastrar a ocorrência.'
  } finally { loading.value = false }
}

onMounted(async () => {
  await searchStudents()
  options.value = await incidentOptions()
})
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center"><img src="/logo_ifms.png" width="160"><div class="text-sm">SIGOE - Controle de ocorrências escolares - <span class="text-green-600">Sair</span></div></header>
    <div class="flex flex-col md:flex-row flex-1"><Sidebar :activePage="'ocorrencias'" /><main class="flex-1 p-6"><Breadcrumb :items="breadcrumbItems" /><h1 class="text-2xl font-bold mb-6">Cadastrar Nova Ocorrência</h1>
      <form @submit.prevent="handleSubmit" class="space-y-6">
        <Card title="Estudante"><div class="grid grid-cols-6 gap-6"><div class="col-span-4"><label class="block text-sm font-medium mb-1">Pesquisar estudante</label><input v-model="studentSearch" type="search" placeholder="Nome, R.A. ou matrícula" class="block w-full px-3 py-2 border rounded-md"><div class="border rounded-md mt-2 max-h-56 overflow-y-auto"><div v-if="loadingStudents" class="p-3 text-sm">Buscando...</div><label v-for="student in visibleStudents" :key="student.id" class="flex gap-2 p-2"><input type="checkbox" :checked="isSelected(student.id)" @change="toggleStudent(student)"><span>{{ student.name }}{{ student.ra ? ` - ${student.ra}` : '' }}</span></label></div></div><div class="col-span-2"><Select id="studentType" label="Estudante é?" v-model="selectedStudentType" :options="[{ value: 'non_resident', label: 'Não residente' }, { value: 'resident', label: 'Residente' }]" /></div></div><div v-if="selectedStudents.length" class="mt-4"><p class="text-sm font-medium">Estudantes selecionados</p><ul class="list-disc ml-5 text-sm"><li v-for="student in selectedStudents" :key="student.id">{{ student.name }}</li></ul></div></Card>
        <Card title="Assistente"><div class="grid grid-cols-6 gap-6"><div class="col-span-3"><Select id="assistant" label="Assistente" v-model="selectedAssistant" :options="assistantOptions" /></div><div class="col-span-3"><Select id="sector" label="Encaminhar para" v-model="selectedSector" :options="[{ value: '', label: 'Não enviar notificação' }, ...sectorOptions]" /></div></div></Card>
        <Card title="Ocorrência"><div class="grid grid-cols-12 gap-4"><div class="col-span-3"><Input v-model="dateIncident" type="date" label="Data ocorrência" /></div><div class="col-span-3"><Input v-model="timeIncident" type="time" label="Hora ocorrência" /></div><div class="col-span-3"><Select id="occurrenceType" label="Tipo da ocorrência" v-model="selectedOccurrenceType" :options="occurrenceOptions" /></div><div class="col-span-3"><Select id="accessType" label="Tipo de acesso" v-model="selectedAccessType" :options="[{ value: 'public', label: 'Público' }, { value: 'private', label: 'Privado' }]" /></div></div><textarea v-model="description" rows="5" class="w-full border rounded-md mt-4" placeholder="Ocorrência"></textarea><div class="grid grid-cols-6 gap-6 mt-4"><div class="col-span-3"><Select id="sanction" label="Sanção aplicada" v-model="selectedSanction" :options="options.sanctions" /></div><div class="col-span-3"><Select id="resolved" label="Ocorrência resolvida?" v-model="occurrenceResolved" :options="[{ value: 'no_', label: 'Não' }, { value: 'yes_', label: 'Sim' }]" /></div></div></Card>
        <Card title="Direitos e deveres do estudante"><label v-for="item in options.student_duties" :key="item.id" class="flex gap-2 mb-2"><input type="checkbox" :value="item.id" v-model="studentDuties"><span>{{ item.item }}</span></label></Card>
        <Card title="Proibições e responsabilidades"><label v-for="item in options.prohibition_and_responsibilities" :key="item.id" class="flex gap-2 mb-2"><input type="checkbox" :value="item.id" v-model="prohibitions"><span>{{ item.item }}</span></label></Card>
        <Card title="Descrição da solução"><textarea v-model="solution" rows="5" class="w-full border rounded-md" placeholder="Solução"></textarea></Card>
        <p v-if="errorMessage" class="text-red-600">{{ errorMessage }}</p><p v-if="successMessage" class="text-green-600">{{ successMessage }}</p><Button type="submit" :disabled="loading">{{ loading ? 'Salvando...' : 'Salvar' }}</Button>
      </form></main></div>
  </div>
</template>
