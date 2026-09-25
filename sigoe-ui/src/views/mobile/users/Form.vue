<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'

import MobileLayout from '@/layouts/MobileLayout.vue'
import { create, find, update, options } from '@/services/users'
import { error, success } from '@/utils/sweetPopup2'

const route = useRoute()
const router = useRouter()
const editing = !!route.params.id

const form = ref({
  name: '',
  email: '',
  siape: '',
  polo_id: '',
  username: '',
  password: '',
  password_confirmation: '',
  admin: false,
  status: true,
  avatar: null
})

const campi = ref([])
const loading = ref(false)
const errorMessage = ref('')

onMounted(async () => {
  try {
    const response = await options()

    campi.value = response?.polos || []

    if (editing) {
      const result = await find(route.params.id)

      form.value = {
        ...form.value,
        ...result.user
      }
    }
  } catch (e) {
    errorMessage.value = 'Não foi possível carregar os dados do usuário.'
  }
})

const save = async () => {
  loading.value = true

  try {
    if (editing) {
      await update(route.params.id, form.value)
      await success('Usuário atualizado com sucesso!')
    } else {
      await create(form.value)
      await success('Usuário cadastrado com sucesso!')
    }

    await router.push(
      editing
        ? `/mobile/users/${route.params.id}`
        : '/mobile/users'
    )
  } catch (e) {
    await error(
      e.response?.data?.errors?.join(', ') ||
        'Não foi possível salvar o usuário.'
    )
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <MobileLayout
    :mobile-title="editing ? 'Editar usuário' : 'Novo usuário'"
  >
    <form
      @submit.prevent="save"
      class="space-y-4"
    >
      <div class="rounded-xl bg-white p-4 shadow-sm">
        <h2 class="font-semibold">Dados pessoais</h2>

        <div class="mt-4 space-y-3">
          <input
            v-model="form.name"
            required
            placeholder="Nome completo"
            class="w-full rounded-lg border px-3 py-3"
          />

          <input
            v-model="form.email"
            type="email"
            required
            placeholder="Email institucional"
            class="w-full rounded-lg border px-3 py-3"
          />

          <input
            v-model="form.siape"
            placeholder="SIAPE"
            class="w-full rounded-lg border px-3 py-3"
          />
        </div>
      </div>

      <div class="rounded-xl bg-white p-4 shadow-sm">
        <h2 class="font-semibold">Acesso</h2>

        <div class="mt-4 space-y-3">
          <input
            v-model="form.username"
            required
            placeholder="Nome de usuário"
            class="w-full rounded-lg border px-3 py-3"
          />

          <input
            v-model="form.password"
            type="password"
            :required="!editing"
            placeholder="Senha"
            class="w-full rounded-lg border px-3 py-3"
          />

          <input
            v-model="form.password_confirmation"
            type="password"
            :required="!editing"
            placeholder="Confirmar senha"
            class="w-full rounded-lg border px-3 py-3"
          />

          <label class="flex items-center gap-2 text-sm">
            <input
              v-model="form.admin"
              type="checkbox"
            />
            Administrador
          </label>

          <label class="flex items-center gap-2 text-sm">
            <input
              v-model="form.status"
              type="checkbox"
            />
            Usuário ativo
          </label>
        </div>
      </div>

      <div class="rounded-xl bg-white p-4 shadow-sm">
        <label class="text-sm font-medium">
          Campus

          <select
            v-model="form.polo_id"
            class="mt-1 w-full rounded-lg border px-3 py-3"
          >
            <option value="">Selecione</option>

            <option
              v-for="campus in campi"
              :key="campus.id"
              :value="campus.id"
            >
              {{ campus.name }}
            </option>
          </select>
        </label>
      </div>

      <div
        v-if="errorMessage"
        class="rounded-xl bg-red-50 p-4 text-sm text-red-700"
      >
        {{ errorMessage }}
      </div>

      <div class="grid grid-cols-2 gap-2">
        <RouterLink
          :to="
            editing
              ? `/mobile/users/${route.params.id}`
              : '/mobile/users'
          "
          class="rounded-lg bg-gray-100 px-4 py-3 text-center"
        >
          Cancelar
        </RouterLink>

        <button
          :disabled="loading"
          class="rounded-lg bg-green-600 px-4 py-3 text-white"
        >
          {{ loading ? 'Salvando...' : 'Salvar' }}
        </button>
      </div>
    </form>
  </MobileLayout>
</template>
