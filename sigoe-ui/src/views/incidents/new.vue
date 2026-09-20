<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import Swal from 'sweetalert2'
import Sidebar from '@/components/sidebar.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Button from '@/components/ui/button.vue'
import Select from '@/components/ui/select.vue'
import StudentSearchableSelect from '@/components/ui/student-searchable-select.vue'
import Input from '@/components/ui/input.vue'
import Card from '@/components/ui/card.vue'
import { create as createIncident, options as incidentOptions } from '@/services/incidents'
import { can } from '@/services/permissions'

const router = useRouter()
const breadcrumbItems = [{ label: 'Home', href: '/' }, { label: 'Administrador', href: '/' }, { label: 'Ocorrências', href: '/ocorrencias/ocorrencias/listar' }, { label: 'Nova', href: '/ocorrencias/ocorrencias/nova' }]
const selectedStudents = ref([])
const options = ref({ assistants: [], sectors: [], type_incidents: [], student_duties: [], prohibition_and_responsibilities: [], sanctions: [] })
const selectedStudentType = ref('non_resident')
const selectedAssistant = ref('')
const selectedSector = ref('')
const selectedOccurrenceType = ref('')
const selectedAccessType = ref('public')
const selectedSanction = ref('')
const occurrenceResolved = ref('no_')
const dateIncident = ref(new Date().toISOString().split('T')[0])
const timeIncident = ref(new Date().toTimeString().slice(0, 5))
const description = ref('')
const solution = ref('')
const studentDuties = ref([])
const prohibitions = ref([])
const loading = ref(false)
const errorMessage = ref('')
const successMessage = ref('')
const assistantOptions = computed(() => options.value.assistants.map(item => ({ value: String(item.id), label: `${item.name}${item.email ? ` - ${item.email}` : ''}` })))
const sectorOptions = computed(() => options.value.sectors.map(item => ({ value: String(item.id), label: `${item.name}${item.email ? ` - ${item.email}` : ''}` })))
const occurrenceOptions = computed(() => options.value.type_incidents.map(item => ({ value: String(item.id), label: item.name })))
const selectedStudentIds = computed(() => selectedStudents.value.map(student => student.id))
const canApplySanction = computed(() => can('occurrences', 'sanction'))

const showError = async message => {
  errorMessage.value = message
  await Swal.fire({ title: 'Erro!', text: message, icon: 'error', confirmButtonText: 'OK' })
}

const handleSubmit = async () => {
  errorMessage.value = ''
  successMessage.value = ''
  if (!selectedStudentIds.value.length) return showError('Selecione pelo menos um estudante.')
  loading.value = true
  try {
    const payload = { student_ids: selectedStudentIds.value, type_student: selectedStudentType.value, assistant_id: selectedAssistant.value, sector_id: selectedSector.value || null, type_incident_id: selectedOccurrenceType.value, visibility: selectedAccessType.value, date_incident: dateIncident.value, time_incident: timeIncident.value, description: description.value }
    if (canApplySanction.value) Object.assign(payload, { sanction: selectedSanction.value || null, is_resolved: occurrenceResolved.value, soluction: solution.value, student_duty_ids: studentDuties.value, prohibition_and_responsibility_ids: prohibitions.value })
    const response = await createIncident(payload)
    if (response.error) return showError(Array.isArray(response.error) ? response.error.join(', ') : response.error)
    successMessage.value = 'Ocorrência cadastrada para os estudantes selecionados.'
    await Swal.fire({ title: 'Sucesso!', text: successMessage.value, icon: 'success', confirmButtonText: 'OK' })
    router.push('/ocorrencias/ocorrencias/listar')
  } catch (error) {
    await showError(error.response?.data?.errors?.join(', ') || 'Não foi possível cadastrar a ocorrência.')
  } finally { loading.value = false }
}

onMounted(async () => { options.value = await incidentOptions() })
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center"><img src="/logo_ifms.png" width="160"><div class="text-sm">SIGOE - Controle de ocorrências escolares - <span class="text-green-600">Sair</span></div></header>
    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'ocorrencias'" />
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <h1 class="text-2xl font-bold mb-6">Cadastrar Nova Ocorrência</h1>
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <Card title="Estudante">
            <div class="grid grid-cols-6 gap-6">
              <div class="col-span-4"><StudentSearchableSelect v-model="selectedStudents" /></div>
              <div class="col-span-2"><Select id="studentType" label="Estudante é?" v-model="selectedStudentType" :options="[{ value: 'non_resident', label: 'Não residente' }, { value: 'resident', label: 'Residente' }]" /></div>
            </div>
          </Card>
          <Card title="Assistente">
            <div class="grid grid-cols-6 gap-6"><div class="col-span-3"><Select id="assistant" label="Assistente" v-model="selectedAssistant" :options="assistantOptions" /></div><div class="col-span-3"><Select id="sector" label="Encaminhar para" v-model="selectedSector" :options="[{ value: '', label: 'Não enviar notificação' }, ...sectorOptions]" /></div></div>
          </Card>
          <Card title="Ocorrência">
            <div class="grid grid-cols-12 gap-4"><div class="col-span-3"><Input v-model="dateIncident" type="date" label="Data ocorrência" /></div><div class="col-span-3"><Input v-model="timeIncident" type="time" label="Hora ocorrência" /></div><div class="col-span-3"><Select id="occurrenceType" label="Tipo da ocorrência" v-model="selectedOccurrenceType" :options="occurrenceOptions" /></div><div class="col-span-3"><Select id="accessType" label="Tipo de acesso" v-model="selectedAccessType" :options="[{ value: 'public', label: 'Público' }, { value: 'private', label: 'Privado' }]" /></div></div>
            <textarea v-model="description" rows="5" class="border-2 border-gray-300 bg-white w-full border rounded-md mt-4 p-3" placeholder="Ocorrência"></textarea>
            <template v-if="canApplySanction"><div class="grid grid-cols-6 gap-6 mt-4"><div class="col-span-3"><Select id="sanction" label="Sanção aplicada" v-model="selectedSanction" :options="options.sanctions" /></div><div class="col-span-3"><Select id="resolved" label="Ocorrência resolvida?" v-model="occurrenceResolved" :options="[{ value: 'no_', label: 'Não' }, { value: 'yes_', label: 'Sim' }]" /></div></div><Card title="Direitos e deveres do estudante"><label v-for="item in options.student_duties" :key="item.id" class="flex gap-2 mb-2"><input type="checkbox" :value="item.id" v-model="studentDuties"><span>{{ item.item }}</span></label></Card><Card title="Proibições e responsabilidades"><label v-for="item in options.prohibition_and_responsibilities" :key="item.id" class="flex gap-2 mb-2"><input type="checkbox" :value="item.id" v-model="prohibitions"><span>{{ item.item }}</span></label></Card><Card title="Descrição da solução"><textarea v-model="solution" rows="5" class="border-2 border-gray-300 bg-white w-full border rounded-md p-3" placeholder="Solução"></textarea></Card></template>
          <p v-if="errorMessage" class="text-red-600">{{ errorMessage }}</p><p v-if="successMessage" class="text-green-600">{{ successMessage }}</p>
          <Button type="submit" :disabled="loading">{{ loading ? 'Salvando...' : 'Salvar' }}</Button>
        </form>
      </main>
    </div>
  </div>
</template>
