<script setup>
import { ref, computed, onMounted } from 'vue'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Select from '@/components/ui/select.vue'
import SearchableSelect from '@/components/ui/searchable-select.vue'
import Input from '@/components/ui/input.vue'
import Header from '@/components/header.vue'
import { getIncidentReportOptions, generateIncidentReport } from '@/services/reports/incidents'
import { error, warning } from '@/utils/sweetPopup2'

const breadcrumbItems = [
  { label: 'Home', href: '/' },
  { label: 'Ocorrências', href: '/ocorrencias' },
  { label: 'Relatório ocorrências', href: '/ocorrencias/relatorio' }
]

const selectedStudent = ref('')
const selectedCourse = ref('')
const selectedClass = ref('')
const selectedOccurrenceType = ref('')
const selectedResident = ref('')
const selectedResolved = ref('')
const startDate = ref('')
const endDate = ref('')
const selectedQuickFilter = ref(7)

const options = ref({
  students: [],
  courses: [],
  school_groups: [],
  type_incidents: []
})

const isGenerating = ref(false)
const isLoadingOptions = ref(false)

const studentOptions = computed(() => [
  { value: '', label: 'Todos os estudantes' },
  ...options.value.students.map(item => ({
    value: String(item.id),
    label: item.name
  }))
])

const courseOptions = computed(() => [
  { value: '', label: 'Todos os cursos' },
  ...options.value.courses.map(item => ({
    value: String(item.id),
    label: item.name
  }))
])

const classOptions = computed(() => [
  { value: '', label: 'Todas as turmas' },
  ...options.value.school_groups.map(item => ({
    value: String(item.id),
    label: item.name
  }))
])

const occurrenceOptions = computed(() => [
  { value: '', label: 'Todos os tipos' },
  ...options.value.type_incidents.map(item => ({
    value: String(item.id),
    label: item.name
  }))
])

const isFormValid = computed(() => (
  startDate.value &&
  endDate.value &&
  startDate.value <= endDate.value
))

const hasFilters = computed(() => (
  selectedStudent.value ||
  selectedCourse.value ||
  selectedClass.value ||
  selectedOccurrenceType.value ||
  selectedResident.value ||
  selectedResolved.value ||
  startDate.value ||
  endDate.value
))

const filters = computed(() => ({
  student: selectedStudent.value,
  course: selectedCourse.value,
  school_group: selectedClass.value,
  type_incident_id: selectedOccurrenceType.value,
  type_student: selectedResident.value,
  is_resolved: selectedResolved.value,
  date_start: startDate.value,
  date_final: endDate.value
}))

const setQuickFilter = days => {
  selectedQuickFilter.value = days

  const today = new Date()
  const pastDate = new Date()

  pastDate.setDate(today.getDate() - days)

  endDate.value = today.toISOString().split('T')[0]
  startDate.value = pastDate.toISOString().split('T')[0]
}

const handleGenerateReport = async () => {
  if (!isFormValid.value) {
    error('Informe um período válido, com data inicial e final.')
    return
  }

  isGenerating.value = true

  try {
    await generateIncidentReport(filters.value)
  } catch (err) {
    let message = 'Não foi possível gerar o relatório.'

    if (err.response?.data instanceof Blob) {
      try {
        const data = JSON.parse(await err.response.data.text())
        message = data.error || message
      } catch (_) {
        message = 'Não foi possível gerar o relatório.'
      }
    } else {
      message = err.response?.data?.error || message
    }

    warning(message)
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
  setQuickFilter(7)
}

const loadOptions = async () => {
  isLoadingOptions.value = true

  try {
    options.value = await getIncidentReportOptions()
  } catch (err) {
    error(err.response?.data?.errors?.join(', ') || 'Não foi possível carregar os filtros do relatório.')
  } finally {
    isLoadingOptions.value = false
  }
}

onMounted(async () => {
  setQuickFilter(7)
  await loadOptions()
})
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />
    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'relatorio'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <div class="flex justify-between items-center mb-6">
          <h1 class="text-2xl font-bold">
            Relatório de Ocorrências
          </h1>

          <Button v-if="hasFilters" @click="clearFilters"
            customClass="bg-gray-500 hover:bg-gray-600 focus:ring-gray-500">
            Limpar Filtros
          </Button>
        </div>

        <Card customClass="mb-4" title="Filtros Rápidos" icon="filter">
          <div class="flex flex-wrap gap-2">
            <Button @click="setQuickFilter(7)"
              :customClass="selectedQuickFilter === 7 ? 'bg-green-700 text-sm' : 'bg-blue-500 hover:bg-blue-600 text-sm'">
              Últimos 7 dias
            </Button>

            <Button @click="setQuickFilter(30)"
              :customClass="selectedQuickFilter === 30 ? 'bg-green-700 text-sm' : 'bg-blue-500 hover:bg-blue-600 text-sm'">
              Últimos 30 dias
            </Button>

            <Button @click="setQuickFilter(90)"
              :customClass="selectedQuickFilter === 90 ? 'bg-green-700 text-sm' : 'bg-blue-500 hover:bg-blue-600 text-sm'">
              Últimos 3 meses
            </Button>

            <Button @click="setQuickFilter(365)"
              :customClass="selectedQuickFilter === 365 ? 'bg-green-700 text-sm' : 'bg-blue-500 hover:bg-blue-600 text-sm'">
              Último ano
            </Button>
          </div>
        </Card>

        <form @submit.prevent="handleGenerateReport" class="space-y-6">
          <Card customClass="mb-4" title="Período *" icon="calendar">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <Input v-model="startDate" type="date" required />
              <Input v-model="endDate" type="date" required />
            </div>
          </Card>

          <Card customClass="mb-4" title="Estudante e Curso" icon="user-graduate">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <SearchableSelect v-model="selectedStudent" :options="studentOptions" placeholder="Todos os estudantes"
                :disabled="isLoadingOptions" />
              <SearchableSelect v-model="selectedCourse" :options="courseOptions" placeholder="Todos os cursos"
                :disabled="isLoadingOptions" />
            </div>
          </Card>

          <Card customClass="mb-4" title="Dados da Ocorrência" icon="exclamation-triangle">
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              <SearchableSelect v-model="selectedOccurrenceType" :options="occurrenceOptions"
                placeholder="Todos os tipos" :disabled="isLoadingOptions" />

              <Select v-model="selectedResident"
                :options="[{ value: '', label: 'Residente?' }, { value: 'resident', label: 'Sim' }, { value: 'non_resident', label: 'Não' }]" />

              <Select v-model="selectedResolved"
                :options="[{ value: '', label: 'Resolvida?' }, { value: 'yes_', label: 'Sim' }, { value: 'no_', label: 'Não' }]" />

              <SearchableSelect v-model="selectedClass" :options="classOptions" placeholder="Todas as turmas"
                :disabled="isLoadingOptions" />
            </div>
          </Card>

          <div>
            <Button type="submit" :disabled="!isFormValid || isGenerating || isLoadingOptions"
              customClass="bg-green-600 hover:bg-green-700">
              {{ isGenerating ? 'Gerando...' : 'Exportar PDF' }}
            </Button>
          </div>
        </form>
      </main>
    </div>
  </div>
</template>