<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MobileLayout from '@/layouts/MobileLayout.vue'
import StudentSearchableSelect from '@/components/ui/student-searchable-select.vue'
import { create, find, options, update } from '@/services/incidents'
import { can } from '@/services/permissions'

const route = useRoute(), router = useRouter()
const editing = computed(() => Boolean(route.params.id))
const id = computed(() => route.params.id)
const students = ref([])
const incident = ref(null)
const opts = ref({ assistants: [], sectors: [], type_incidents: [], student_duties: [], prohibition_and_responsibilities: [], sanctions: [] })
const form = ref({ type_student:'non_resident', assistant_id:'', sector_id:'', type_incident_id:'', visibility:'public', date_incident:new Date().toISOString().slice(0,10), time_incident:new Date().toTimeString().slice(0,5), description:'', sanction:'', is_resolved:'no_', soluction:'' })
const duties = ref([]), prohibitions = ref([]), loading = ref(true), saving = ref(false), errorMessage = ref('')

const assistantOptions = computed(() => opts.value.assistants.map(x => ({ value:String(x.id), label:x.name + (x.email ? ' - ' + x.email : '') })))
const sectorOptions = computed(() => opts.value.sectors.map(x => ({ value:String(x.id), label:x.name + (x.email ? ' - ' + x.email : '') })))

onMounted(async () => {
  try {
    opts.value = await options()
    if (editing.value) {
      const response = await find(id.value); incident.value = response.incident
      const x = incident.value
      form.value = { ...form.value, type_student:x.type_student || 'non_resident', assistant_id:String(x.assistant_id || x.assistant?.id || ''), sector_id:String(x.sector_id || ''), type_incident_id:String(x.type_incident_id || x.type_incident?.id || ''), visibility:x.visibility || 'public', date_incident:x.date_incident || '', time_incident:x.time_incident || '', description:x.description || '', sanction:x.sanction || '', is_resolved:x.is_resolved || 'no_', soluction:x.soluction || '' }
      duties.value = (x.student_duties || []).map(i => i.id); prohibitions.value = (x.prohibition_and_responsibilities || []).map(i => i.id)
    }
  } catch (e) { errorMessage.value = e.response?.data?.errors?.join(', ') || 'Não foi possível carregar o formulário.' }
  finally { loading.value = false }
})

const save = async () => {
  if (!editing.value && !students.value.length) { errorMessage.value = 'Selecione pelo menos um estudante.'; return }
  saving.value = true; errorMessage.value = ''
  try {
    const payload = { ...form.value, student_duty_ids:duties.value, prohibition_and_responsibility_ids:prohibitions.value }
    if (editing.value) {
      const response = await update(id.value, payload)
      if (response.error) throw new Error(Array.isArray(response.error) ? response.error.join(', ') : response.error)
      await router.push('/mobile/incidents/' + id.value)
    } else {
      const response = await create({ ...payload, student_ids:students.value.map(s => s.id) })
      if (response.error) throw new Error(Array.isArray(response.error) ? response.error.join(', ') : response.error)
      await router.push('/mobile/incidents')
    }
  } catch (e) { errorMessage.value = e.response?.data?.errors?.join(', ') || e.message || 'Não foi possível salvar a ocorrência.' }
  finally { saving.value = false }
}
</script>

<template>
  <MobileLayout :mobile-title="editing ? 'Editar ocorrência' : 'Nova ocorrência'">
    <div v-if="loading" class="py-10 text-center text-sm text-gray-500">Carregando...</div>
    <form v-else class="space-y-4" @submit.prevent="save">
      <div v-if="errorMessage" class="rounded-lg bg-red-50 p-3 text-sm text-red-700">{{ errorMessage }}</div>

      <section class="rounded-xl bg-white p-4 shadow-sm">
        <h2 class="mb-3 font-semibold">Estudante</h2>
        <StudentSearchableSelect v-if="!editing" v-model="students" />
        <div v-else class="text-sm"><p class="font-medium">{{ incident?.student?.name }}</p><p class="text-gray-500">R.A.: {{ incident?.student?.ra || 'Não informado' }}</p></div>
        <label class="mt-4 block text-sm"><span class="mb-1 block text-gray-600">Estudante é?</span><select v-model="form.type_student" class="w-full rounded-lg border px-3 py-2"><option value="non_resident">Não residente</option><option value="resident">Residente</option></select></label>
      </section>

      <section class="rounded-xl bg-white p-4 shadow-sm">
        <h2 class="mb-3 font-semibold">Responsáveis</h2>
        <label class="block text-sm"><span class="mb-1 block text-gray-600">Assistente</span><select v-model="form.assistant_id" class="w-full rounded-lg border px-3 py-2"><option value="">Selecione</option><option v-for="x in assistantOptions" :key="x.value" :value="x.value">{{ x.label }}</option></select></label>
        <label class="mt-3 block text-sm"><span class="mb-1 block text-gray-600">Encaminhar para</span><select v-model="form.sector_id" class="w-full rounded-lg border px-3 py-2"><option value="">Não enviar notificação</option><option v-for="x in sectorOptions" :key="x.value" :value="x.value">{{ x.label }}</option></select></label>
      </section>

      <section class="rounded-xl bg-white p-4 shadow-sm">
        <h2 class="mb-3 font-semibold">Ocorrência</h2>
        <div class="grid grid-cols-2 gap-3">
          <label class="text-sm"><span class="mb-1 block text-gray-600">Data</span><input v-model="form.date_incident" type="date" class="w-full rounded-lg border px-3 py-2" /></label>
          <label class="text-sm"><span class="mb-1 block text-gray-600">Hora</span><input v-model="form.time_incident" type="time" class="w-full rounded-lg border px-3 py-2" /></label>
        </div>
        <label class="mt-3 block text-sm"><span class="mb-1 block text-gray-600">Tipo</span><select v-model="form.type_incident_id" class="w-full rounded-lg border px-3 py-2"><option value="">Selecione</option><option v-for="x in opts.type_incidents" :key="x.id" :value="String(x.id)">{{ x.name }}</option></select></label>
        <label class="mt-3 block text-sm"><span class="mb-1 block text-gray-600">Visibilidade</span><select v-model="form.visibility" class="w-full rounded-lg border px-3 py-2"><option value="public">Pública</option><option value="private">Privada</option></select></label>
        <textarea v-model="form.description" rows="5" class="mt-3 w-full rounded-lg border p-3" placeholder="Descrição"></textarea>
      </section>

      <section v-if="can('occurrences','sanction')" class="space-y-4">
        <div class="rounded-xl bg-white p-4 shadow-sm">
          <h2 class="mb-3 font-semibold">Sanção e resolução</h2>
          <select v-model="form.sanction" class="w-full rounded-lg border px-3 py-2"><option value="">Não se aplica</option><option v-for="x in opts.sanctions" :key="x.id || x.value" :value="x.value || x.id">{{ x.name || x.label }}</option></select>
          <select v-model="form.is_resolved" class="mt-3 w-full rounded-lg border px-3 py-2"><option value="no_">Não resolvida</option><option value="yes_">Resolvida</option></select>
        </div>
        <div class="rounded-xl bg-white p-4 shadow-sm">
          <h2 class="mb-3 font-semibold">Direitos e deveres</h2>
          <label v-for="x in opts.student_duties" :key="x.id" class="mb-2 flex gap-2 text-sm"><input v-model="duties" type="checkbox" :value="x.id" /><span>{{ x.item }}</span></label>
        </div>
        <div class="rounded-xl bg-white p-4 shadow-sm">
          <h2 class="mb-3 font-semibold">Proibições</h2>
          <label v-for="x in opts.prohibition_and_responsibilities" :key="x.id" class="mb-2 flex gap-2 text-sm"><input v-model="prohibitions" type="checkbox" :value="x.id" /><span>{{ x.item }}</span></label>
        </div>
        <div class="rounded-xl bg-white p-4 shadow-sm">
          <h2 class="mb-3 font-semibold">Descrição da solução</h2>
          <textarea v-model="form.soluction" rows="4" class="w-full rounded-lg border p-3"></textarea>
        </div>
      </section>

      <div class="flex gap-2">
        <button type="button" class="flex-1 rounded-lg border bg-white px-4 py-3" @click="router.back()">Cancelar</button>
        <button type="submit" class="flex-1 rounded-lg bg-green-600 px-4 py-3 text-white disabled:opacity-50" :disabled="saving">{{ saving ? 'Salvando...' : 'Salvar' }}</button>
      </div>
    </form>
  </MobileLayout>
</template>