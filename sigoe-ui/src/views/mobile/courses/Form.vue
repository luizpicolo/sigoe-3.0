<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import MobileLayout from '@/layouts/MobileLayout.vue'
import { find, create, update } from '@/services/courses'
import { can } from '@/services/permissions'

const route = useRoute(), router = useRouter(), editing = !!route.params.id
const form = ref({ name: '', initial: '', polo_id: null }), loading = ref(false), errorMessage = ref('')

onMounted(async () => {
  if (!editing) return
  try { form.value = { ...form.value, ...(await find(route.params.id)) } }
  catch (e) { errorMessage.value = e.response?.data?.errors?.join(', ') || 'Não foi possível carregar o curso.' }
})
const save = async () => {
  loading.value = true; errorMessage.value = ''
  try {
    const payload = { name: form.value.name, initial: form.value.initial, polo_id: form.value.polo_id }
    if (editing) await update(route.params.id, payload); else await create(payload)
    await router.push('/mobile/courses')
  } catch (e) {
    errorMessage.value = e.response?.data?.errors?.join(', ') || 'Não foi possível salvar o curso.'
  } finally { loading.value = false }
}
</script>
<template>
  <MobileLayout :mobile-title="editing ? 'Editar curso' : 'Novo curso'">
    <form @submit.prevent="save" class="space-y-4">
      <div class="rounded-xl bg-white p-4 shadow-sm">
        <h2 class="font-semibold">Dados do curso</h2>
        <div class="mt-4 space-y-3">
          <label class="block text-sm font-medium">Nome<input v-model="form.name" required class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-3"></label>
          <label class="block text-sm font-medium">Sigla<input v-model="form.initial" class="mt-1 w-full rounded-lg border border-gray-300 px-3 py-3"></label>
        </div>
      </div>
      <div v-if="errorMessage" class="rounded-xl bg-red-50 p-4 text-sm text-red-700">{{ errorMessage }}</div>
      <div class="grid grid-cols-2 gap-2">
        <RouterLink to="/mobile/courses" class="rounded-lg bg-gray-100 px-4 py-3 text-center text-sm">Cancelar</RouterLink>
        <button :disabled="loading || (editing ? !can('courses','update') : !can('courses','create'))" class="rounded-lg bg-green-600 px-4 py-3 text-sm text-white disabled:opacity-50">{{ loading ? 'Salvando...' : 'Salvar' }}</button>
      </div>
    </form>
  </MobileLayout>
</template>