<script setup>
import { ref, computed, onMounted } from 'vue'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Select from '@/components/ui/select.vue'
import Input from '@/components/ui/input.vue'
import Header from '@/components/header.vue'
import { getIncidentReportOptions, generateIncidentReport } from '@/services/reports/incidents'

const breadcrumbItems = [{ label: 'Home', href: '/' }, { label: 'Ocorrências', href: '/ocorrencias' }, { label: 'Relatório ocorrências', href: '/ocorrencias/relatorio' }]
const selectedStudent = ref('')
const selectedCourse = ref('')
const selectedClass = ref('')
const selectedOccurrenceType = ref('')
const selectedResident = ref('')
const selectedResolved = ref('')
const startDate = ref('')
const endDate = ref('')
const options = ref({ students: [], courses: [], school_groups: [], type_incidents: [] })
const isGenerating = ref(false)
const isLoadingOptions = ref(false)
const errorMessage = ref('')

const isFormValid = computed(() => startDate.value && endDate.value && startDate.value <= endDate.value)
const hasFilters = computed(() => selectedStudent.value || selectedCourse.value || selectedClass.value || selectedOccurrenceType.value || selectedResident.value || selectedResolved.value || startDate.value || endDate.value)
const studentOptions = computed(() => [{ value: '', label: 'Todos os estudantes' }, ...options.value.students.map(item => ({ value: String(item.id), label: item.name }))])
const courseOptions = computed(() => [{ value: '', label: 'Todos os cursos' }, ...options.value.courses.map(item => ({ value: String(item.id), label: item.name }))])
const classOptions = computed(() => [{ value: '', label: 'Todas as turmas' }, ...options.value.school_groups.map(item => ({ value: String(item.id), label: item.name }))])
const occurrenceOptions = computed(() => [{ value: '', label: 'Todos os tipos' }, ...options.value.type_incidents.map(item => ({ value: String(item.id), label: item.name }))])
const filters = computed(() => ({ student: selectedStudent.value, course: selectedCourse.value, school_group: selectedClass.value, type_incident_id: selectedOccurrenceType.value, type_student: selectedResident.value, is_resolved: selectedResolved.value, date_start: startDate.value, date_final: endDate.value }))

const handleGenerateReport = async () => {
  errorMessage.value = ''
  if (!isFormValid.value) {
    errorMessage.value = 'Informe um período válido, com data inicial e final.'
    return
  }
  isGenerating.value = true
  try {
    await generateIncidentReport(filters.value)
  } catch (error) {
    errorMessage.value = error.response?.data?.error || 'Não foi possível gerar o relatório.'
  } finally {
    isGenerating.value = false
  }
}

const clearFilters = () => {
  selectedStudent.value = ''
  selectedCourse.value = ''
  selectedClass.value = ''
  selectedOccurrenceType.value = ''
  selectedResident.value = ''
  selectedResolved.value = ''
  startDate.value = ''
  endDate.value = ''
}

const setQuickFilter = days => {
  const today = new Date()
  const pastDate = new Date()
  pastDate.setDate(today.getDate() - days)
  endDate.value = today.toISOString().split('T')[0]
  startDate.value = pastDate.toISOString().split('T')[0]
}

onMounted(async () => {
  isLoadingOptions.value = true
  try {
    options.value = await getIncidentReportOptions()
  } catch (error) {
    errorMessage.value = 'Não foi possível carregar os filtros do relatório.'
  } finally {
    isLoadingOptions.value = false
  }
})
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />
    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'relatorio'" />
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <div class="flex justify-between items-center mb-6"><h1 class="text-2xl font-bold">Relatório de Ocorrências</h1><Button v-if="hasFilters" @click="clearFilters" customClass="bg-gray-500 hover:bg-gray-600 focus:ring-gray-500"><i class="fa-solid fa-eraser mr-1"></i>Limpar Filtros</Button></div>
        <Card customClass="mb-4" title="Filtros Rápidos" icon="filter"><div class="flex flex-wrap gap-2"><Button @click="setQuickFilter(7)" customClass="bg-blue-500 hover:bg-blue-600 text-sm">Últimos 7 dias</Button><Button @click="setQuickFilter(30)" customClass="bg-blue-500 hover:bg-blue-600 text-sm">Últimos 30 dias</Button><Button @click="setQuickFilter(90)" customClass="bg-blue-500 hover:bg-blue-600 text-sm">Últimos 3 meses</Button><Button @click="setQuickFilter(365)" customClass="bg-blue-500 hover:bg-blue-600 text-sm">Último ano</Button></div></Card>
        <form @submit.prevent="handleGenerateReport" class="space-y-6">
          <Card customClass="mb-4" title="Período *" icon="calendar"><div class="grid grid-cols-1 md:grid-cols-2 gap-6"><div><label class="block text-sm font-medium text-gray-700 mb-1">Data início *</label><Input v-model="startDate" type="date" required /></div><div><label class="block text-sm font-medium text-gray-700 mb-1">Data final *</label><Input v-model="endDate" type="date" required /></div></div></Card>
          <Card customClass="mb-4" title="Estudante e Curso" icon="user-graduate"><div class="grid grid-cols-1 md:grid-cols-2 gap-6"><div><label class="block text-sm font-medium text-gray-700 mb-1">Estudante</label><Select v-model="selectedStudent" :options="studentOptions" :disabled="isLoadingOptions" /></div><div><label class="block text-sm font-medium text-gray-700 mb-1">Curso</label><Select v-model="selectedCourse" :options="courseOptions" :disabled="isLoadingOptions" /></div></div></Card>
          <Card customClass="mb-4" title="Dados da Ocorrência" icon="exclamation-triangle"><div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6"><div><label class="block text-sm font-medium text-gray-700 mb-1">Tipo de Ocorrência</label><Select v-model="selectedOccurrenceType" :options="occurrenceOptions" :disabled="isLoadingOptions" /></div><div><label class="block text-sm font-medium text-gray-700 mb-1">Residente?</label><Select v-model="selectedResident" :options="[{ value: '', label: 'Todos' }, { value: 'resident', label: 'Sim' }, { value: 'non_resident', label: 'Não' }]" /></div><div><label class="block text-sm font-medium text-gray-700 mb-1">Resolvida?</label><Select v-model="selectedResolved" :options="[{ value: '', label: 'Todas' }, { value: 'yes_', label: 'Sim' }, { value: 'no_', label: 'Não' }]" /></div><div><label class="block text-sm font-medium text-gray-700 mb-1">Turma</label><Select v-model="selectedClass" :options="classOptions" :disabled="isLoadingOptions" /></div></div></Card>
          <p v-if="errorMessage" class="text-sm text-red-600">{{ errorMessage }}</p>
          <div class="flex justify-start gap-3"><Button type="submit" :disabled="!isFormValid || isGenerating || isLoadingOptions" customClass="bg-green-600 hover:bg-green-700"><i v-if="!isGenerating" class="fa-solid fa-download mr-1"></i><i v-else class="fa-solid fa-spinner fa-spin mr-1"></i>{{ isGenerating ? 'Gerando...' : 'Exportar PDF' }}</Button></div>
        </form>
        <Card customClass="bg-gray-50 border-gray-200" title="Dicas para gerar relatórios" icon="info-circle"><ul class="text-xs text-gray-600 space-y-1"><li>• As datas de início e fim são obrigatórias.</li><li>• Use os filtros rápidos para períodos comuns.</li><li>• Campos vazios incluem todos os registros da categoria.</li></ul></Card>
      </main>
    </div>
  </div>
</template>
