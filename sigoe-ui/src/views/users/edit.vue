<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { find, update } from '@/services/users'
import Header from '@/components/header.vue'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Alert from '@/components/ui/alert.vue'

const route = useRoute()
const router = useRouter()
const loading = ref(true)
const isSubmitting = ref(false)
const errorMessage = ref('')
const successMessage = ref('')

const form = ref({
  name: '',
  email: '',
  username: '',
  siape: '',
  polo_id: '',
  admin: false,
  status: true,
  password: '',
  password_confirmation: ''
})

const breadcrumbItems = [
  { label: 'Home', href: '/home' },
  { label: 'Administrador', href: '/administrador' },
  { label: 'Usuários', href: '/administrador/usuarios/listar' },
  { label: 'Editar Usuário', href: `/administrador/usuarios/editar/${route.params.id}` }
]

onMounted(async () => {
  try {
    const result = await find(route.params.id)
    form.value = { ...form.value, ...result.user }
  } catch (error) {
    errorMessage.value = 'Não foi possível carregar o usuário.'
  } finally {
    loading.value = false
  }
})

const submit = async () => {
  errorMessage.value = ''
  successMessage.value = ''
  isSubmitting.value = true

  try {
    await update(route.params.id, form.value)
    successMessage.value = 'Usuário atualizado com sucesso!'
    setTimeout(() => {
      router.push(`/administrador/usuarios/visualizar/${route.params.id}`)
    }, 1000)
  } catch (error) {
    errorMessage.value = error.response?.data?.errors?.join(', ') || 'Erro ao atualizar usuário.'
  } finally {
    isSubmitting.value = false
  }
}

const dismissError = () => {
  errorMessage.value = ''
}

const dismissSuccess = () => {
  successMessage.value = ''
}
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'usuarios'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <div class="flex items-center justify-between mb-6">
          <h1 class="text-2xl font-bold">Alterar informações do usuário</h1>
          <Button variant="secondary" :to="`/administrador/usuarios/visualizar/${route.params.id}`">
            <i class="fa-solid fa-arrow-left mr-2"></i>
            Voltar
          </Button>
        </div>

        <Alert
          v-if="errorMessage"
          type="error"
          :message="errorMessage"
          dismissible
          @dismiss="dismissError"
          class="mb-4"
        />

        <Alert
          v-if="successMessage"
          type="success"
          :message="successMessage"
          dismissible
          @dismiss="dismissSuccess"
          class="mb-4"
        />

        <div v-if="loading" class="py-8 text-center text-gray-600">
          Carregando informações do usuário...
        </div>

        <form v-else @submit.prevent="submit" class="space-y-6">
          <Card customClass="mb-4" title="Dados Pessoais">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 p-1">
              <Input id="name" name="name" label="Nome Completo*" v-model="form.name" placeholder="Nome completo do usuário" required />
              <Input id="siape" name="siape" label="SIAPE" v-model="form.siape" placeholder="Número SIAPE" />
            </div>
          </Card>

          <Card customClass="mb-4" title="Dados institucionais">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 p-1">
              <Input id="email" name="email" type="email" label="Email Institucional*" v-model="form.email" placeholder="email@ifms.edu.br" required />
              <Input id="polo_id" name="polo_id" label="Polo" v-model="form.polo_id" placeholder="Identificador do polo" />
            </div>
          </Card>

          <Card customClass="mb-4" title="Dados de Acesso">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 p-1">
              <Input id="username" name="username" label="Nome de Usuário*" v-model="form.username" placeholder="nome.usuario" required />
              <Input id="password" name="password" type="password" label="Nova senha (opcional)" v-model="form.password" placeholder="••••••••" />
              <Input id="password_confirmation" name="password_confirmation" type="password" label="Confirmar nova senha" v-model="form.password_confirmation" placeholder="••••••••" />
            </div>

            <div class="flex flex-col sm:flex-row gap-6 mt-6 p-1">
              <label class="flex items-center gap-2">
                <input type="checkbox" v-model="form.admin" />
                Administrador?
              </label>
              <label class="flex items-center gap-2">
                <input type="checkbox" v-model="form.status" />
                Usuário ativo?
              </label>
            </div>
          </Card>

          <div class="flex justify-end space-x-3">
            <Button variant="secondary" :to="`/administrador/usuarios/visualizar/${route.params.id}`">
              <i class="fa-solid fa-times mr-2"></i>
              Cancelar
            </Button>
            <Button type="submit" variant="success" :loading="isSubmitting" :disabled="isSubmitting">
              <i v-if="!isSubmitting" class="fa-solid fa-save mr-2"></i>
              {{ isSubmitting ? 'Salvando...' : 'Salvar alterações' }}
            </Button>
          </div>
        </form>
      </main>
    </div>
  </div>
</template>
