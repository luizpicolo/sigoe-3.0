<script setup>
import { onMounted, ref } from 'vue'
import MobileLayout from '@/layouts/MobileLayout.vue'
import { show } from '@/services/dashboard'
import { can } from '@/services/permissions'

const dashboard = ref(null)
const loading = ref(true)
const errorMessage = ref('')

onMounted(async () => {
  try { dashboard.value = await show() }
  catch { errorMessage.value = 'Não foi possível carregar o dashboard.' }
  finally { loading.value = false }
})
</script>

<template>
  <MobileLayout mobile-title="Dashboard">
    <div v-if="loading" class="py-10 text-center text-sm text-gray-500">Carregando...</div>
    <div v-else-if="errorMessage" class="rounded-xl bg-red-50 p-4 text-sm text-red-700">{{ errorMessage }}</div>
    <div v-else class="space-y-4">
      <section class="rounded-xl bg-white p-4 shadow-sm">
        <h2 class="font-semibold">Resumo</h2>
        <div class="mt-3 grid grid-cols-2 gap-3 text-sm">
          <div class="rounded-lg bg-gray-50 p-3"><span class="text-gray-500">Anos</span><p class="mt-1 font-medium">{{ dashboard?.by_years?.length || 0 }}</p></div>
          <div class="rounded-lg bg-gray-50 p-3"><span class="text-gray-500">Cursos</span><p class="mt-1 font-medium">{{ dashboard?.by_courses?.length || 0 }}</p></div>
        </div>
      </section>
      <section v-if="can('occurrences','read')" class="rounded-xl bg-white p-4 shadow-sm">
        <h2 class="font-semibold">Acesso rápido</h2>
        <div class="mt-3 grid grid-cols-2 gap-3">
          <RouterLink to="/mobile/incidents" class="rounded-lg bg-gray-100 p-3 text-center text-sm">Ocorrências</RouterLink>
          <RouterLink v-if="can('occurrences','create')" to="/mobile/incidents/new" class="rounded-lg bg-green-600 p-3 text-center text-sm text-white">Nova ocorrência</RouterLink>
        </div>
      </section>
    </div>
  </MobileLayout>
</template>