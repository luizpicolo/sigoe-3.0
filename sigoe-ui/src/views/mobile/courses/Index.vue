<script setup>
import { onMounted, ref } from 'vue'
import MobileLayout from '@/layouts/MobileLayout.vue'
import { list, remove } from '@/services/courses'
import { can } from '@/services/permissions'

const page = ref(1), amount = ref(10), order = ref('id'), search = ref('')
const courses = ref([]), total = ref(0), loading = ref(false), errorMessage = ref('')

const load = async () => {
  loading.value = true; errorMessage.value = ''
  try {
    const response = await list(page.value, order.value, search.value, amount.value)
    courses.value = response?.courses || []; total.value = response?.total || 0
  } catch (e) {
    errorMessage.value = e.response?.data?.errors?.join(', ') || 'Não foi possível carregar os cursos.'
  } finally { loading.value = false }
}
const searchCourses = () => { page.value = 1; load() }
const destroy = async id => {
  if (!window.confirm('Excluir este curso?')) return
  try { await remove(id); await load() } catch (e) {
    errorMessage.value = e.response?.data?.errors?.join(', ') || 'Não foi possível excluir o curso.'
  }
}
onMounted(load)
</script>

<template>
  <MobileLayout mobile-title="Cursos">
    <div class="space-y-4">
      <div class="flex items-center justify-between">
        <div>
          <h2 class="text-lg font-semibold">Cursos</h2>
          <p class="text-xs text-gray-500">{{ total }} registro(s)</p>
        </div>
        <RouterLink v-if="can('courses','create')" to="/mobile/courses/new" class="rounded-lg bg-green-600 px-3 py-2 text-sm text-white">
          <i class="fa-solid fa-plus mr-1"></i>Novo
        </RouterLink>
      </div>

      <div class="rounded-xl bg-white p-3 shadow-sm">
        <div class="flex gap-2">
          <input v-model="search" @keyup.enter="searchCourses" type="search" placeholder="Buscar curso..." class="min-w-0 flex-1 rounded-lg border border-gray-300 px-3 py-2 text-sm">
          <button @click="searchCourses" class="rounded-lg bg-gray-100 px-3 py-2 text-sm"><i class="fa-solid fa-magnifying-glass"></i></button>
        </div>
        <select v-model="order" @change="page=1;load()" class="mt-2 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm">
          <option value="id">Ordenar por ID</option>
          <option value="name">Ordenar por nome</option>
        </select>
      </div>

      <div v-if="loading" class="py-10 text-center text-sm text-gray-500">Carregando cursos...</div>
      <div v-else-if="errorMessage" class="rounded-xl bg-red-50 p-4 text-sm text-red-700">{{ errorMessage }}</div>
      <div v-else class="space-y-3">
        <article v-for="course in courses" :key="course.id" class="rounded-xl bg-white p-4 shadow-sm">
          <div class="flex items-start justify-between gap-3">
            <div class="min-w-0">
              <p class="text-xs text-gray-500">#{{ course.id }}</p>
              <h3 class="mt-1 font-semibold break-words">{{ course.name }}</h3>
              <p class="mt-1 text-sm text-gray-500">{{ course.initial || 'Sem sigla' }}</p>
              <p v-if="course.polo?.name" class="mt-1 text-xs text-gray-500">Polo: {{ course.polo.name }}</p>
            </div>
            <i class="fa-solid fa-book-open text-lg text-gray-400"></i>
          </div>
          <div class="mt-4 grid grid-cols-2 gap-2">
            <RouterLink v-if="can('courses','update')" :to="`/mobile/courses/${course.id}/edit`" class="rounded-lg bg-blue-600 px-3 py-2 text-center text-sm text-white">Editar</RouterLink>
            <button v-if="can('courses','destroy')" @click="destroy(course.id)" class="rounded-lg bg-red-50 px-3 py-2 text-sm text-red-700">Excluir</button>
          </div>
        </article>
        <div v-if="!courses.length" class="rounded-xl bg-white p-6 text-center text-sm text-gray-500">Nenhum curso encontrado.</div>
      </div>

      <div v-if="!loading && total > amount" class="flex items-center justify-between rounded-xl bg-white p-3 text-sm shadow-sm">
        <button :disabled="page <= 1" @click="page--;load()" class="rounded-lg bg-gray-100 px-3 py-2 disabled:opacity-40">Anterior</button>
        <span>Página {{ page }} de {{ Math.max(1, Math.ceil(total / amount)) }}</span>
        <button :disabled="page >= Math.ceil(total / amount)" @click="page++;load()" class="rounded-lg bg-gray-100 px-3 py-2 disabled:opacity-40">Próxima</button>
      </div>
    </div>
  </MobileLayout>
</template>