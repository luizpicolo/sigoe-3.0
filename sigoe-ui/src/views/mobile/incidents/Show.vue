<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MobileLayout from '@/layouts/MobileLayout.vue'
import { find, remove } from '@/services/incidents'
import { can } from '@/services/permissions'

const route = useRoute(), router = useRouter()
const incident = ref(null), loading = ref(true), errorMessage = ref('')
const sanctionLabels = { verbal_warning:'Advertência Verbal', written_warning:'Advertência escrita', suspension:'Suspensão', quitting_school:'Desligamento' }

onMounted(async () => {
  try { incident.value = (await find(route.params.id)).incident }
  catch { errorMessage.value = 'Não foi possível carregar a ocorrência.' }
  finally { loading.value = false }
})
const deleteIncident = async () => {
  if (!confirm('Excluir esta ocorrência?')) return
  await remove(route.params.id); await router.push('/mobile/incidents')
}
const formatDate = x => x ? new Date(x + 'T00:00:00').toLocaleDateString('pt-BR') : '-'
</script>

<template>
  <MobileLayout mobile-title="Detalhes da ocorrência">
    <div v-if="loading" class="py-10 text-center text-sm text-gray-500">Carregando...</div>
    <div v-else-if="errorMessage" class="rounded-xl bg-red-50 p-4 text-sm text-red-700">{{ errorMessage }}</div>
    <div v-else class="space-y-4">
      <section class="rounded-xl bg-white p-4 shadow-sm">
        <div class="flex items-start justify-between gap-3"><div><p class="text-xs text-gray-500">#{{ incident.id }}</p><h2 class="mt-1 text-lg font-semibold">{{ incident.student?.name }}</h2><p class="text-sm text-gray-500">{{ incident.course?.name }}</p></div><span class="rounded-full bg-gray-100 px-2 py-1 text-xs">{{ incident.visibility === 'private' ? 'Privada' : 'Pública' }}</span></div>
      </section>
      <section class="rounded-xl bg-white p-4 shadow-sm">
        <h2 class="mb-3 font-semibold">Informações</h2>
        <dl class="space-y-3 text-sm">
          <div><dt class="text-gray-500">Data</dt><dd>{{ formatDate(incident.date_incident) }}</dd></div>
          <div><dt class="text-gray-500">Tipo</dt><dd>{{ incident.type_incident?.name || '-' }}</dd></div>
          <div><dt class="text-gray-500">Assistente</dt><dd>{{ incident.assistant?.name || incident.user?.name || '-' }}</dd></div>
          <div><dt class="text-gray-500">Setor</dt><dd>{{ incident.sector?.name || 'Não encaminhado' }}</dd></div>
          <div><dt class="text-gray-500">Descrição</dt><dd class="whitespace-pre-wrap">{{ incident.description || '-' }}</dd></div>
        </dl>
      </section>
      <section v-if="can('occurrences','sanction')" class="space-y-4">
        <div class="rounded-xl bg-white p-4 shadow-sm"><h2 class="mb-3 font-semibold">Status</h2><p class="text-sm">Sanção: {{ sanctionLabels[incident.sanction] || 'Nenhuma' }}</p><p class="mt-2 text-sm">Resolvida: {{ incident.is_resolved ? 'Sim' : 'Não' }}</p></div>
        <div class="rounded-xl bg-white p-4 shadow-sm"><h2 class="mb-3 font-semibold">Direitos e deveres</h2><ul class="space-y-2 text-sm"><li v-for="x in incident.student_duties" :key="x.id">{{ x.item }}</li><li v-if="!incident.student_duties?.length" class="text-gray-500">Nenhum item.</li></ul></div>
        <div class="rounded-xl bg-white p-4 shadow-sm"><h2 class="mb-3 font-semibold">Proibições</h2><ul class="space-y-2 text-sm"><li v-for="x in incident.prohibition_and_responsibilities" :key="x.id">{{ x.item }}</li><li v-if="!incident.prohibition_and_responsibilities?.length" class="text-gray-500">Nenhum item.</li></ul></div>
        <div class="rounded-xl bg-white p-4 shadow-sm"><h2 class="mb-3 font-semibold">Solução</h2><p class="whitespace-pre-wrap text-sm">{{ incident.soluction || 'Nenhuma solução descrita.' }}</p></div>
      </section>
      <div class="grid grid-cols-2 gap-2">
        <button v-if="can('occurrences','update')" class="rounded-lg bg-blue-600 px-3 py-3 text-sm text-white" @click="router.push('/mobile/incidents/' + incident.id + '/edit')">Editar</button>
        <button v-if="can('occurrences','destroy')" class="rounded-lg bg-red-600 px-3 py-3 text-sm text-white" @click="deleteIncident">Excluir</button>
      </div>
    </div>
  </MobileLayout>
</template>