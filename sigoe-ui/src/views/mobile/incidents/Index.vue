<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import MobileLayout from '@/layouts/MobileLayout.vue'
import { list } from '@/services/incidents'
import { can, permissionState } from '@/services/permissions'
import { error } from '@/utils/sweetPopup2'

const router = useRouter()
const incidents = ref([])
const total = ref(0)
const page = ref(1)
const amount = ref(10)
const search = ref('')
const loading = ref(false)

const restricted = computed(() => permissionState.permissions?.occurrences?.can_read_restricted === true && !permissionState.admin && permissionState.user?.super_admin !== true)
const canAccess = incident => (!restricted.value && (incident.visibility !== 'private' || permissionState.admin || permissionState.user?.super_admin === true || incident.user?.id === permissionState.user?.id)) || (restricted.value && incident.user?.id === permissionState.user?.id)

const load = async () => {
  loading.value = true
  try {
    const response = await list(page.value, 'id', search.value || null, amount.value)
    incidents.value = response?.incidents || []
    total.value = response?.total || 0
  } catch (e) { error(e.response?.data?.errors?.join(', ') || 'Não foi possível carregar as ocorrências.') }
  finally { loading.value = false }
}

const formatDate = value => value ? new Date(value + 'T00:00:00').toLocaleDateString('pt-BR') : '-'
const doSearch = () => { page.value = 1; load() }

onMounted(load)
</script>

<template>
  <MobileLayout mobile-title="Ocorrências">
    <div class="space-y-4">
      <div class="flex gap-2">
        <input v-model="search" @keyup.enter="doSearch" class="min-w-0 flex-1 rounded-lg border px-3 py-2 text-sm" placeholder="Buscar..." />
        <button class="rounded-lg bg-green-600 px-4 py-2 text-sm text-white" @click="doSearch"><i class="fa-solid fa-search"></i></button>
      </div>

      <button v-if="can('occurrences','create')" class="w-full rounded-xl bg-green-600 px-4 py-3 font-medium text-white" @click="router.push('/mobile/incidents/new')">
        <i class="fa-solid fa-plus mr-2"></i>Nova ocorrência
      </button>

      <div v-if="loading" class="py-10 text-center text-sm text-gray-500">Carregando ocorrências...</div>
      <div v-else-if="!incidents.length" class="rounded-xl bg-white p-6 text-center text-sm text-gray-500 shadow-sm">Nenhuma ocorrência encontrada.</div>

      <div v-else class="space-y-3">
        <article v-for="incident in incidents" :key="incident.id" class="rounded-xl bg-white p-4 shadow-sm">
          <div class="flex items-start justify-between gap-3">
            <div>
              <p class="text-xs text-gray-500">#{{ incident.id }} · {{ formatDate(incident.date_incident) }}</p>
              <h2 class="mt-1 font-semibold">{{ incident.student?.name || 'Estudante não informado' }}</h2>
              <p class="text-sm text-gray-500">{{ incident.course?.name || 'Curso não informado' }}</p>
            </div>
            <span class="rounded-full px-2 py-1 text-xs" :class="incident.visibility === 'private' ? 'bg-red-50 text-red-700' : 'bg-green-50 text-green-700'">{{ incident.visibility === 'private' ? 'Privada' : 'Pública' }}</span>
          </div>
          <p class="mt-2 line-clamp-2 text-sm text-gray-600">{{ incident.description || 'Sem descrição.' }}</p>
          <button :disabled="!canAccess(incident)" class="mt-3 w-full rounded-lg border px-3 py-2 text-sm disabled:opacity-40" @click="router.push('/mobile/incidents/' + incident.id)">Visualizar</button>
        </article>
      </div>

      <div v-if="total > amount" class="flex items-center justify-between rounded-xl bg-white p-3 text-sm shadow-sm">
        <button class="rounded-lg border px-3 py-2 disabled:opacity-40" :disabled="page === 1" @click="page--; load()">Anterior</button>
        <span>Página {{ page }} de {{ Math.ceil(total / amount) }}</span>
        <button class="rounded-lg border px-3 py-2 disabled:opacity-40" :disabled="page >= Math.ceil(total / amount)" @click="page++; load()">Próxima</button>
      </div>
    </div>
  </MobileLayout>
</template>