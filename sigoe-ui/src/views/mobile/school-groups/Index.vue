<script setup>
import { onMounted, ref } from 'vue'
import MobileLayout from '@/layouts/MobileLayout.vue'
import { list, remove } from '@/services/school_groups'
import { can } from '@/services/permissions'
import { error, success, confirm } from '@/utils/sweetPopup2'

const page = ref(1), amount = ref(10), order = ref('id'), search = ref('')
const groups = ref([]), total = ref(0), loading = ref(false), errorMessage = ref('')

const load = async () => {
  loading.value = true; errorMessage.value = ''
  try {
    const response = await list(page.value, order.value, search.value, amount.value)
    groups.value = response?.school_groups || []; total.value = response?.total || 0
  } catch (e) {
    errorMessage.value = e.response?.data?.errors?.join(', ') || 'Não foi possível carregar as turmas.'
  } finally { loading.value = false }
}
const searchGroups = () => { page.value = 1; load() }
const destroy = async id => {
  if (!await confirm('Deseja realmente excluir esta turma?')) return
  try { await remove(id); await success('Turma excluída com sucesso!'); await load() } catch (e) {
    await error(e.response?.data?.errors?.join(', ') || 'Não foi possível excluir a turma.')
  }
}
onMounted(load)
</script>

<template>
  <MobileLayout mobile-title="Turmas">
    <div class="space-y-4">
      <div class="flex items-center justify-between">
        <div><h2 class="text-lg font-semibold">Turmas</h2><p class="text-xs text-gray-500">{{ total }} registro(s)</p></div>
        <RouterLink v-if="can('classes','create')" to="/mobile/school-groups/new" class="rounded-lg bg-green-600 px-3 py-2 text-sm text-white"><i class="fa-solid fa-plus mr-1"></i>Nova</RouterLink>
      </div>

      <div class="rounded-xl bg-white p-3 shadow-sm">
        <div class="flex gap-2">
          <input v-model="search" @keyup.enter="searchGroups" type="search" placeholder="Buscar turma..." class="min-w-0 flex-1 rounded-lg border border-gray-300 px-3 py-2 text-sm">
          <button @click="searchGroups" class="rounded-lg bg-gray-100 px-3 py-2 text-sm"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <select v-model="order" @change="page=1;load()" class="mt-2 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm">
          <option value="id">Ordenar por ID</option><option value="name">Ordenar por nome</option>
        </select>
      </div>

      <div v-if="loading" class="py-10 text-center text-sm text-gray-500">Carregando turmas...</div>
      <div v-else-if="errorMessage" class="rounded-xl bg-red-50 p-4 text-sm text-red-700">{{ errorMessage }}</div>
      <div v-else class="space-y-3">
        <article v-for="group in groups" :key="group.id" class="rounded-xl bg-white p-4 shadow-sm">
          <div class="flex items-start justify-between gap-3">
            <div class="min-w-0"><p class="text-xs text-gray-500">#{{ group.id }}</p><h3 class="mt-1 font-semibold break-words">{{ group.name }}</h3><p class="mt-1 text-sm text-gray-500">{{ group.identifier || 'Sem identificador' }}</p><p v-if="group.polo?.name" class="mt-1 text-xs text-gray-500">Polo: {{ group.polo.name }}</p></div>
            <i class="fa-solid fa-users text-lg text-gray-400"></i>
          </div>
          <div class="mt-4 grid grid-cols-2 gap-2">
            <RouterLink v-if="can('classes','update')" :to="`/mobile/school-groups/${group.id}/edit`" class="rounded-lg bg-blue-600 px-3 py-2 text-center text-sm text-white">Editar</RouterLink>
            <button v-if="can('classes','destroy')" @click="destroy(group.id)" class="rounded-lg bg-red-50 px-3 py-2 text-sm text-red-700">Excluir</button>
          </div>
        </article>
        <div v-if="!groups.length" class="rounded-xl bg-white p-6 text-center text-sm text-gray-500">Nenhuma turma encontrada.</div>
      </div>

      <div v-if="!loading && total > amount" class="flex items-center justify-between rounded-xl bg-white p-3 text-sm shadow-sm">
        <button :disabled="page <= 1" @click="page--;load()" class="rounded-lg bg-gray-100 px-3 py-2 disabled:opacity-40">Anterior</button>
        <span>Página {{ page }} de {{ Math.max(1, Math.ceil(total / amount)) }}</span>
        <button :disabled="page >= Math.ceil(total / amount)" @click="page++;load()" class="rounded-lg bg-gray-100 px-3 py-2 disabled:opacity-40">Próxima</button>
      </div>
    </div>
  </MobileLayout>
</template>