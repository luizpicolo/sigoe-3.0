<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Button from '@/components/ui/button.vue'
import Select from '@/components/ui/select.vue'
import Input from '@/components/ui/input.vue'
import Card from '@/components/ui/card.vue'
import Header from '@/components/header.vue'
import { find as findIncident, options as incidentOptions, update as updateIncident } from '@/services/incidents'

const route = useRoute()
const incidentId = route.params.id

const breadcrumbItems = [{ label: 'Home', href: '/' }, { label: 'Ocorrências', href: '/ocorrencias' }, { label: 'Ocorrências', href: '/ocorrencias/ocorrencias/listar' }, { label: 'Editar', href: `/ocorrencias/ocorrencias/editar/${incidentId}` }]

const incident = ref(null)
const options = ref({ assistants: [], sectors: [], type_incidents: [], student_duties: [], prohibition_and_responsibilities: [], sanctions: [] })
const selectedStudentType = ref('')
const selectedAssistant = ref('')
const selectedSector = ref('')
const selectedOccurrenceType = ref('')
const selectedAccessType = ref('public')
const selectedSanction = ref('')
const occurrenceResolved = ref('no_')
const occurrenceDate = ref('')
const occurrenceTime = ref('')
const occurrenceDescription = ref('')
const solutionDescription = ref('')
const studentDuties = ref([])
const prohibitions = ref([])
const loading = ref(true)
const saving = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const assistantOptions = computed(() => options.value.assistants.map(item => ({ value: String(item.id), label: `${item.name}${item.email ? ` - ${item.email}` : ''}` })))

const sectorOptions = computed(() => options.value.sectors.map(item => ({ value: String(item.id), label: `${item.name}${item.email ? ` - ${item.email}` : ''}` })))

const occurrenceOptions = computed(() => options.value.type_incidents.map(item => ({ value: String(item.id), label: item.name })))

const campusName = computed(() => incident.value?.course?.polo?.name || incident.value?.course?.campus || 'Não informado')

const loadData = async () => {
  loading.value = true

  try {
    const [incidentResponse, optionsResponse] = await Promise.all([findIncident(incidentId), incidentOptions()])

    incident.value = incidentResponse.incident
    options.value = optionsResponse

    const data = incident.value

    selectedStudentType.value = data.type_student || ''
    selectedAssistant.value = data.assistant_id ? String(data.assistant_id) : data.assistant?.id ? String(data.assistant.id) : ''
    selectedSector.value = data.sector_id ? String(data.sector_id) : ''
    selectedOccurrenceType.value = data.type_incident_id ? String(data.type_incident_id) : data.type_incident?.id ? String(data.type_incident.id) : ''
    selectedAccessType.value = data.visibility || 'public'
    selectedSanction.value = data.sanction || ''
    occurrenceResolved.value = data.is_resolved || 'no_'
    occurrenceDate.value = data.date_incident || ''
    occurrenceTime.value = data.time_incident || ''
    occurrenceDescription.value = data.description || ''
    solutionDescription.value = data.soluction || ''
    studentDuties.value = (data.student_duties || []).map(item => item.id)
    prohibitions.value = (data.prohibition_and_responsibilities || []).map(item => item.id)
  } catch (error) {
    errorMessage.value = error.response?.data?.errors?.join(', ') || 'Não foi possível carregar a ocorrência.'
  } finally {
    loading.value = false
  }
}

const handleSubmit = async () => {
  errorMessage.value = ''
  successMessage.value = ''
  saving.value = true

  const response = await updateIncident(incidentId, {
    type_student: selectedStudentType.value,
    assistant_id: selectedAssistant.value,
    sector_id: selectedSector.value || null,
    type_incident_id: selectedOccurrenceType.value,
    visibility: selectedAccessType.value,
    sanction: selectedSanction.value || null,
    is_resolved: occurrenceResolved.value,
    date_incident: occurrenceDate.value,
    time_incident: occurrenceTime.value,
    description: occurrenceDescription.value,
    soluction: solutionDescription.value,
    student_duty_ids: studentDuties.value,
    prohibition_and_responsibility_ids: prohibitions.value
  })

  if (response.error) {
    errorMessage.value = Array.isArray(response.error) ? response.error.join(', ') : response.error
  } else {
    successMessage.value = 'Ocorrência atualizada com sucesso.'
  }

  saving.value = false
}

onMounted(loadData)
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'ocorrencias'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">
          Editar Ocorrência #{{ incidentId }}
        </h1>

        <div v-if="loading" class="p-4">
          Carregando ocorrência...
        </div>

        <form v-else @submit.prevent="handleSubmit" class="space-y-6">
          <Card title="Estudante">
            <div class="grid grid-cols-6 gap-6">
              <div class="col-span-4">
                <p class="text-sm font-medium text-gray-700">
                  Estudante
                </p>

                <p class="mt-2">
                  {{ incident?.student?.name || 'Não informado' }}
                </p>

                <p class="text-sm text-gray-500">
                  R.A.: {{ incident?.student?.ra || 'Não informado' }}
                </p>

                <p class="text-sm text-gray-500">
                  Turma: {{ incident?.course?.name || 'Não informado' }}
                </p>

                <p class="text-sm text-gray-500">
                  Campus: {{ campusName }}
                </p>
              </div>

              <div class="col-span-2">
                <Select id="studentType" label="Estudante é?" v-model="selectedStudentType" :options="[{ value: 'non_resident', label: 'Não residente' }, { value: 'resident', label: 'Residente' }]" />
              </div>
            </div>
          </Card>

          <Card title="Assistente">
            <div class="grid grid-cols-6 gap-6">
              <div class="col-span-3">
                <Select id="assistant" label="Assistente" v-model="selectedAssistant" :options="assistantOptions" />
              </div>

              <div class="col-span-3">
                <Select id="sector" label="Encaminhar para" v-model="selectedSector" :options="[{ value: '', label: 'Não enviar notificação' }, ...sectorOptions]" />
              </div>
            </div>
          </Card>

          <Card title="Ocorrência">
            <div class="grid grid-cols-12 gap-4">
              <div class="col-span-3">
                <Input v-model="occurrenceDate" type="date" label="Data ocorrência" />
              </div>

              <div class="col-span-3">
                <Input v-model="occurrenceTime" type="time" label="Hora ocorrência" />
              </div>

              <div class="col-span-3">
                <Select id="occurrenceType" label="Tipo da ocorrência" v-model="selectedOccurrenceType" :options="occurrenceOptions" />
              </div>

              <div class="col-span-3">
                <Select id="accessType" label="Tipo de acesso" v-model="selectedAccessType" :options="[{ value: 'public', label: 'Público' }, { value: 'private', label: 'Privado' }]" />
              </div>
            </div>

            <textarea v-model="occurrenceDescription" rows="5" class="w-full border rounded-md mt-4 border-gray-200 p-3"></textarea>

            <div class="grid grid-cols-6 gap-6 mt-4">
              <div class="col-span-3">
                <Select id="sanction" label="Sanção aplicada" v-model="selectedSanction" :options="[{ value: '', label: 'Sem sanção' }, ...options.sanctions]" />
              </div>

              <div class="col-span-3">
                <Select id="resolved" label="Ocorrência resolvida?" v-model="occurrenceResolved" :options="[{ value: 'no_', label: 'Não' }, { value: 'yes_', label: 'Sim' }]" />
              </div>
            </div>
          </Card>

          <Card title="Direitos e deveres do estudante">
            <label v-for="item in options.student_duties" :key="item.id" class="flex gap-2 mb-2">
              <input type="checkbox" :value="item.id" v-model="studentDuties">
              <span>{{ item.item }}</span>
            </label>
          </Card>

          <Card title="Proibições e responsabilidades">
            <label v-for="item in options.prohibition_and_responsibilities" :key="item.id" class="flex gap-2 mb-2">
              <input type="checkbox" :value="item.id" v-model="prohibitions">
              <span>{{ item.item }}</span>
            </label>
          </Card>

          <Card title="Descrição da solução">
            <textarea v-model="solutionDescription" rows="5" class="w-full border rounded-md border-gray-200 p-3" placeholder="Solução"></textarea>
          </Card>

          <p v-if="errorMessage" class="text-red-600">
            {{ errorMessage }}
          </p>

          <p v-if="successMessage" class="text-green-600">
            {{ successMessage }}
          </p>

          <div class="flex gap-2">
            <Button type="submit" :disabled="saving">
              {{ saving ? 'Salvando...' : 'Atualizar' }}
            </Button>

            <Button :to="`/ocorrencias/ocorrencias/visualizar/${incidentId}`" customClass="bg-white border-gray-200 !text-gray-900">
              Cancelar
            </Button>
          </div>
        </form>
      </main>
    </div>
  </div>
</template>