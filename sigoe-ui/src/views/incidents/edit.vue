```vue
<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'

import { success, error, confirm } from '@/utils/sweetPopup2'
import Sidebar from '@/components/sidebar.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Button from '@/components/ui/button.vue'
import Select from '@/components/ui/select.vue'
import Input from '@/components/ui/input.vue'
import Card from '@/components/ui/card.vue'
import Header from '@/components/header.vue'

import { can } from '@/services/permissions'
import {
  find as findIncident,
  options as incidentOptions,
  update as updateIncident
} from '@/services/incidents'

const route = useRoute()
const router = useRouter()
const incidentId = route.params.id

const incident = ref(null)

const options = ref({
  assistants: [],
  sectors: [],
  type_incidents: [],
  student_duties: [],
  prohibition_and_responsibilities: [],
  sanctions: []
})

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

const assistantOptions = computed(() => options.value.assistants.map(item => ({
  value: String(item.id),
  label: `${item.name}${item.email ? ` - ${item.email}` : ''}`
})))

const sectorOptions = computed(() => options.value.sectors.map(item => ({
  value: String(item.id),
  label: `${item.name}${item.email ? ` - ${item.email}` : ''}`
})))

const occurrenceOptions = computed(() => options.value.type_incidents.map(item => ({
  value: String(item.id),
  label: item.name
})))

const loadData = async () => {
  loading.value = true
  errorMessage.value = ''

  try {
    const [incidentResponse, optionsResponse] = await Promise.all([
      findIncident(incidentId),
      incidentOptions()
    ])

    incident.value = incidentResponse.incident
    options.value = optionsResponse

    const data = incident.value

    selectedStudentType.value = data.type_student || ''
    selectedAssistant.value = String(data.assistant_id || data.assistant?.id || '')
    selectedSector.value = String(data.sector_id || '')
    selectedOccurrenceType.value = String(data.type_incident_id || data.type_incident?.id || '')
    selectedAccessType.value = data.visibility || 'public'
    selectedSanction.value = data.sanction || ''
    occurrenceResolved.value = data.is_resolved || 'no_'
    occurrenceDate.value = data.date_incident || ''
    occurrenceTime.value = data.time_incident || ''
    occurrenceDescription.value = data.description || ''
    solutionDescription.value = data.soluction || ''
    studentDuties.value = (data.student_duties || []).map(item => item.id)
    prohibitions.value = (data.prohibition_and_responsibilities || []).map(item => item.id)
  } catch (err) {
    const message = err.response?.data?.errors?.join(', ') || 'Não foi possível carregar a ocorrência.'
    error({ title: 'Erro!', text: message})
  } finally {
    loading.value = false
  }
}

const handleSubmit = async () => {
  saving.value = true

  try {
    const payload = {
      type_student: selectedStudentType.value,
      assistant_id: selectedAssistant.value,
      sector_id: selectedSector.value || null,
      type_incident_id: selectedOccurrenceType.value,
      visibility: selectedAccessType.value,
      date_incident: occurrenceDate.value,
      time_incident: occurrenceTime.value,
      description: occurrenceDescription.value
    }

    const response = await updateIncident(incidentId, payload)
    if (await success('Ocorrência atualizada com sucesso.')){
      router.push(`/ocorrencias/ocorrencias/visualizar/${incidentId}`)
    }
  } catch (err) {
    const message = err.response?.data?.errors?.join(', ') || 'Não foi possível atualizar a ocorrência.'
    error({ title: 'Erro!', text: message })
  } finally {
    saving.value = false
  }
}

onMounted(loadData)
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'ocorrencias'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="[{ label: 'Home', href: '/' }, { label: 'Ocorrências', href: '/ocorrencias/ocorrencias/listar' }, { label: 'Editar', href: `/ocorrencias/ocorrencias/editar/${incidentId}` }]" />

        <h1 class="text-2xl font-bold mb-6">Editar Ocorrência #{{ incidentId }}</h1>

        <div v-if="loading">Carregando ocorrência...</div>

        <form v-else @submit.prevent="handleSubmit" class="space-y-6">
          <Card title="Estudante">
            <div class="flex items-center gap-4">
              <img :src="incident.student?.photo || '/placeholder.svg?height=96&width=96'" class="h-24 w-24 rounded-full object-cover" alt="Foto do estudante">

              <div>
                <p class="font-medium">{{ incident.student?.name }}</p>
                <p class="text-sm text-gray-500">R.A.: {{ incident.student?.ra || 'Não informado' }}</p>
                <p class="text-sm text-gray-500">Turma: {{ incident.course?.name || 'Não informado' }}</p>
                <p class="text-sm text-gray-500">Campus: {{ incident.course?.polo?.name || 'Não informado' }}</p>
              </div>

              <div class="ml-auto">
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

            <textarea v-model="occurrenceDescription" rows="5" class="w-full border rounded-md mt-4 p-3"></textarea>

            <div v-if="can('occurrences', 'sanction')" class="grid grid-cols-6 gap-6 mt-4">
              <div class="col-span-3">
                <Select id="sanction" label="Sanção aplicada" v-model="selectedSanction" :options="[{ value: '', label: 'Não se aplica' }, ...options.sanctions]" />
              </div>

              <div class="col-span-3">
                <Select id="resolved" label="Ocorrência resolvida?" v-model="occurrenceResolved" :options="[{ value: 'no_', label: 'Não' }, { value: 'yes_', label: 'Sim' }]" />
              </div>
            </div>
          </Card>

          <template v-if="can('occurrences', 'sanction')">
            <Card title="Capítulo III - Direitos e Deveres">
              <label v-for="item in options.student_duties" :key="item.id" class="flex gap-2 mb-2">
                <input type="checkbox" :value="item.id" v-model="studentDuties">
                <span>{{ item.item }}</span>
              </label>
            </Card>

            <Card title="Capítulo IV - Proibições">
              <label v-for="item in options.prohibition_and_responsibilities" :key="item.id" class="flex gap-2 mb-2">
                <input type="checkbox" :value="item.id" v-model="prohibitions">
                <span>{{ item.item }}</span>
              </label>
            </Card>

            <Card title="Descrição da solução">
              <textarea v-model="solutionDescription" rows="5" class="w-full border rounded-md p-3"></textarea>
            </Card>
          </template>

          <p v-if="errorMessage" class="text-red-600">{{ errorMessage }}</p>

          <div class="flex gap-2">
            <Button type="submit" :disabled="saving">{{ saving ? 'Salvando...' : 'Atualizar' }}</Button>
            <Button :to="`/ocorrencias/ocorrencias/visualizar/${incidentId}`" customClass="bg-white border-gray-200 !text-gray-900">Cancelar</Button>
          </div>
        </form>
      </main>
    </div>
  </div>
</template>
```
