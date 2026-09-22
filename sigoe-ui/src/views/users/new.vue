<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { error, success, confirm } from '@/utils/sweetPopup2'
import { create, options } from '@/services/users'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Select from '@/components/ui/select.vue'
import Alert from '@/components/ui/alert.vue'
import Header from '@/components/header.vue'

const router = useRouter()

const breadcrumbItems = [
  { label: 'Home', href: '/home' },
  { label: 'Administrador', href: '/administrador' },
  { label: 'Usuários', href: '/administrador/usuarios/listar' },
  { label: 'Novo Usuário', href: '/administrador/usuarios/novo' }
]

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
const isSubmitting = ref(false)

onMounted(async () => {
  try {
    const response = await options()
    campi.value = response.polos.map(polo => ({ value: polo.id, label: polo.name }))
  } catch (error) {
    error('Não foi possível carregar os campi.')
  }
})

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
    await create(form.value)
    if (await success('Usuário cadastrado com sucesso!')){
      router.push('/administrador/usuarios/listar')
    }
  } catch (error) {
    const errors = error.response?.data?.errors
    const message = Array.isArray(errors) ? errors.join(', ') : errors || 'Erro ao cadastrar usuário. Tente novamente.'
    error(message)
  } finally {
    isSubmitting.value = false
  }
}

const dismissError = () => {
  error('')
}

const dismissSuccess = () => {
  success('')
}
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'usuarios'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">Cadastrar Novo Usuário</h1>

        <Alert v-if="errorMessage" type="error" :message="errorMessage" dismissible @dismiss="dismissError" class="mb-4" />
        <Alert v-if="successMessage" type="success" :message="successMessage" dismissible @dismiss="dismissSuccess" class="mb-4" />

        <form @submit="handleSubmit" class="space-y-6">
          <div class="p-1 rounded-lg shadow-sm">
            <Card customClass="mb-4" title="Dados Pessoais">
              <div class="grid grid-cols-6 gap-6 mb-6 p-1">
                <div class="col-span-4">
                  <Input id="user" name="user" label="Nome Completo*" v-model="form.name" placeholder="Nome completo do usuário" required />
                </div>
                <div class="col-span-1">
                  Foto de Perfil
                  <img :src="photoPreview" width="150" alt="Pré-visualização da foto" srcset="">
                </div>
                <div class="col-span-1">
                  <input ref="fileInput" type="file" accept="image/jpeg,image/png,image/gif" class="hidden" @change="handlePhoto">
                  <Button type="button" customClass="mt-20 w-full bg-green-600 hover:bg-green-700 focus:ring-green-500" @click="selectPhoto">
                    <i class="fa-solid fa-edit"></i>
                    Selecionar foto
                  </Button>
                </div>
              </div>
            </Card>
            <Card customClass="mb-4" title="Dados institucionais">
              <div class="grid grid-cols-6 gap-6 mb-6 p-1">
                <div class="col-span-2">
                  <Input id="email" name="email" type="email" label="Email Institucional*" v-model="form.email" placeholder="email@ifms.edu.br" required />
                </div>
                <div class="col-span-2">
                  <Input id="siape" name="siape" label="SIAPE*" v-model="form.siape" placeholder="Número SIAPE" required />
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
                  <Input id="password" name="password" type="password" label="Senha*" v-model="form.password" placeholder="••••••••" required />
                </div>
                <div class="col-span-2 mt-3">
                  <Input id="confirmPassword" type="password" name="confirmPassword" label="Confirmar senha*" v-model="form.password_confirmation" placeholder="••••••••" required />
                </div>
              </div>

              <div class="grid grid-cols-8 gap-2 mt-4">
                <div class="col-span-1">
                  <input type="checkbox" name="admin" v-model="form.admin" />
                  Administrador?
                </div>
                <div class="col-span-1">
                  <input type="checkbox" name="active" v-model="form.status" />
                  Usuário ativo?
                </div>
              </div>
            </Card>
          </div>
          <div class="flex justify-end space-x-3">
            <Button variant="secondary" to="/administrador/usuarios/listar">
              <i class="fa-solid fa-times mr-2"></i>
              Cancelar
            </Button>
            <Button type="submit" variant="success" :loading="isSubmitting" :disabled="isSubmitting">
              <i v-if="!isSubmitting" class="fa-solid fa-save mr-2"></i>
              {{ isSubmitting ? 'Cadastrando...' : 'Cadastrar usuário' }}
            </Button>
          </div>
        </form>
      </main>
    </div>
  </div>
</template>
