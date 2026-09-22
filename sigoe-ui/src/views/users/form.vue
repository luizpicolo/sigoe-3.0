<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { error, success } from '@/utils/sweetPopup2'
import { create, find, update, options } from '@/services/users'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Select from '@/components/ui/select.vue'
import Header from '@/components/header.vue'

const route = useRoute()
const router = useRouter()
const editing = !!route.params.id
const userId = route.params.id

const loading = ref(editing)
const isSubmitting = ref(false)

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
const photoPreview = ref('/placeholder.svg?height=48&width=48')
const fileInput = ref(null)

const breadcrumbItems = [
  { label: 'Home', href: '/home' },
  { label: 'Administrador', href: '/administrador' },
  { label: 'Usuários', href: '/administrador/usuarios/listar' },
  { label: editing ? 'Editar Usuário' : 'Novo Usuário', href: editing ? `/administrador/usuarios/editar/${userId}` : '/administrador/usuarios/novo' }
]

const loadOptions = async () => {
  try {
    const response = await options()
    campi.value = response.polos.map(polo => ({ value: polo.id, label: polo.name }))
  } catch (e) {
    error(e.response?.data?.errors?.join(', ') || 'Não foi possível carregar os campi.')
  }
}

const loadUser = async () => {
  if (!editing) return

  try {
    const result = await find(userId)

    form.value = {
      ...form.value,
      ...result.user
    }

    if (result.user?.avatar) {
      photoPreview.value = result.user.avatar
    }
  } catch (e) {
    error(e.response?.data?.errors?.join(', ') || 'Não foi possível carregar o usuário.')
  } finally {
    loading.value = false
  }
}

const selectPhoto = () => fileInput.value?.click()

const handlePhoto = event => {
  const file = event.target.files?.[0]
  if (!file) return

  form.value.avatar = file
  photoPreview.value = URL.createObjectURL(file)
}

const handleSubmit = async event => {
  event.preventDefault()
  isSubmitting.value = true

  try {
    if (editing) {
      await update(userId, form.value)
      success('Usuário atualizado com sucesso!')
      await router.push(`/administrador/usuarios/visualizar/${userId}`)
    } else {
      await create(form.value)
      success('Usuário cadastrado com sucesso!')
      await router.push('/administrador/usuarios/listar')
    }
  } catch (e) {
    const errors = e.response?.data?.errors
    const message = Array.isArray(errors) ? errors.join(', ') : errors || `Erro ao ${editing ? 'atualizar' : 'cadastrar'} usuário.`
    error(message)
  } finally {
    isSubmitting.value = false
  }
}

onMounted(async () => {
  await loadOptions()
  await loadUser()
})
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'usuarios'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <div class="flex items-center justify-between mb-6">
          <h1 class="text-2xl font-bold">
            {{ editing ? 'Alterar informações do usuário' : 'Cadastrar Novo Usuário' }}
          </h1>

          <Button v-if="editing" variant="secondary" :to="`/administrador/usuarios/visualizar/${userId}`">
            <i class="fa-solid fa-arrow-left mr-2"></i>
            Voltar
          </Button>
        </div>

        <div v-if="loading" class="py-8 text-center text-gray-600">
          Carregando informações do usuário...
        </div>

        <form v-else @submit.prevent="handleSubmit" class="space-y-6">
          <div class="p-1 rounded-lg shadow-sm">
            <Card customClass="mb-4" title="Dados Pessoais">
              <div class="grid grid-cols-6 gap-6 mb-6 p-1">
                <div class="col-span-4">
                  <Input id="user" name="user" label="Nome Completo*" v-model="form.name" placeholder="Nome completo do usuário" required />
                </div>

                <div class="col-span-1">
                  Foto de Perfil
                  <img :src="photoPreview" width="150" alt="Pré-visualização da foto">
                </div>

                <div class="col-span-1">
                  <input ref="fileInput" type="file" accept="image/jpeg,image/png,image/gif" class="hidden" @change="handlePhoto">
                  <Button type="button" customClass="mt-20 w-full bg-green-600 hover:bg-green-700 focus:ring-green-500" @click="selectPhoto">
                    <i class="fa-solid fa-edit pr-2"></i>
                    Selecionar foto
                  </Button>
                </div>
              </div>

              <div class="grid grid-cols-1 md:grid-cols-2 gap-6 p-1">
                <Input id="siape" name="siape" label="SIAPE" v-model="form.siape" placeholder="Número SIAPE" :required="!editing" />
              </div>
            </Card>

            <Card customClass="mb-4" title="Dados institucionais">
              <div class="grid grid-cols-6 gap-6 mb-6 p-1">
                <div class="col-span-2">
                  <Input id="email" name="email" type="email" label="Email Institucional*" v-model="form.email" placeholder="email@ifms.edu.br" required />
                </div>

                <div class="col-span-2">
                  <Input id="siape" name="siape" label="SIAPE*" v-model="form.siape" placeholder="Número SIAPE" :required="!editing" />
                </div>

                <div class="col-span-2">
                  <Select id="campus" name="campus" label="Campus" v-model="form.polo_id" :options="[{ value: '', label: 'Selecione um campus' }, ...campi]" />
                </div>
              </div>
            </Card>

            <Card title="Dados de Acesso">
              <div class="grid grid-cols-6 gap-6 p-1">
                <div class="col-span-2">
                  <Input id="username" name="username" label="Nome de Usuário*" v-model="form.username" placeholder="nome.usuario" required />
                </div>

                <div class="col-span-2">
                  <Input id="password" name="password" type="password" :label="editing ? 'Nova senha (opcional)' : 'Senha*'" v-model="form.password" placeholder="••••••••" :required="!editing" />
                </div>

                <div class="col-span-2 mt-3">
                  <Input id="password_confirmation" name="password_confirmation" type="password" :label="editing ? 'Confirmar nova senha' : 'Confirmar senha*'" v-model="form.password_confirmation" placeholder="••••••••" :required="!editing" />
                </div>
              </div>

              <div class="grid grid-cols-8 gap-2 mt-4">
                <div class="col-span-1">
                  <input type="checkbox" name="admin" v-model="form.admin">
                  Administrador?
                </div>

                <div class="col-span-1">
                  <input type="checkbox" name="active" v-model="form.status">
                  Usuário ativo?
                </div>
              </div>
            </Card>
          </div>

          <div class="flex justify-start space-x-3">
            <Button variant="secondary" :to="editing ? `/administrador/usuarios/visualizar/${userId}` : '/administrador/usuarios/listar'">
              <i class="fa-solid fa-times mr-2"></i>
              Cancelar
            </Button>

            <Button type="submit" variant="success" :loading="isSubmitting" :disabled="isSubmitting">
              <i v-if="!isSubmitting" class="fa-solid fa-save mr-2"></i>
              {{ isSubmitting ? 'Salvando...' : 'Salvar' }}
            </Button>
          </div>
        </form>
      </main>
    </div>
  </div>
</template>
