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
      <section class="rounded-xl bg-white p-4 shadow-sm">
        <h2 class="font-semibold">Menu</h2>
        <p class="mt-1 text-xs text-gray-500">Acesse as funcionalidades disponíveis para seu perfil.</p>

        <div class="mt-4 space-y-4">
          <div>
            <h3 class="mb-2 text-xs font-semibold uppercase tracking-wide text-gray-500">Ocorrências</h3>
            <div class="grid grid-cols-2 gap-3">
              <RouterLink v-if="can('occurrences','read')" to="/mobile/incidents" class="flex flex-col items-center gap-2 rounded-xl bg-gray-100 p-4 text-center text-sm">
                <i class="fa-solid fa-clipboard-list text-lg"></i>
                <span>Ocorrências</span>
              </RouterLink>
              <RouterLink v-if="can('occurrences','create')" to="/mobile/incidents/new" class="flex flex-col items-center gap-2 rounded-xl bg-green-600 p-4 text-center text-sm text-white">
                <i class="fa-solid fa-plus text-lg"></i>
                <span>Nova ocorrência</span>
              </RouterLink>
              <RouterLink v-if="can('occurrences','read')" to="/ocorrencias/relatorio" class="flex flex-col items-center gap-2 rounded-xl bg-gray-100 p-4 text-center text-sm">
                <i class="fa-solid fa-chart-column text-lg"></i>
                <span>Relatórios</span>
              </RouterLink>
            </div>
          </div>

          <div>
            <h3 class="mb-2 text-xs font-semibold uppercase tracking-wide text-gray-500">Acadêmico</h3>
            <div class="grid grid-cols-2 gap-3">
              <RouterLink v-if="can('students','read')" to="/mobile/students" class="flex flex-col items-center gap-2 rounded-xl bg-gray-100 p-4 text-center text-sm">
                <i class="fa-solid fa-user-graduate text-lg"></i>
                <span>Estudantes</span>
              </RouterLink>
              <RouterLink v-if="can('courses','read')" to="/mobile/courses" class="flex flex-col items-center gap-2 rounded-xl bg-gray-100 p-4 text-center text-sm">
                <i class="fa-solid fa-book-open text-lg"></i>
                <span>Cursos</span>
              </RouterLink>
              <RouterLink v-if="can('classes','read')" to="/mobile/school-groups" class="flex flex-col items-center gap-2 rounded-xl bg-gray-100 p-4 text-center text-sm">
                <i class="fa-solid fa-users text-lg"></i>
                <span>Turmas</span>
              </RouterLink>
            </div>
          </div>

          <div v-if="can('users','read')">
            <h3 class="mb-2 text-xs font-semibold uppercase tracking-wide text-gray-500">Administração</h3>
            <div class="grid grid-cols-2 gap-3">
              <RouterLink to="/mobile/users" class="flex flex-col items-center gap-2 rounded-xl bg-gray-100 p-4 text-center text-sm">
                <i class="fa-solid fa-user-gear text-lg"></i>
                <span>Usuários</span>
              </RouterLink>
            </div>
          </div>
        </div>
      </section>
    </div>
  </MobileLayout>
</template>