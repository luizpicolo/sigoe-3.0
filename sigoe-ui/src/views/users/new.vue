<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
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
  { label: "Home", href: "/home" },
  { label: "Administrador", href: "/administrador" },
  { label: "Usuários", href: "/administrador/usuarios/listar" },
  { label: "Novo Usuário", href: "/administrador/usuarios/novo" }
];

const user = ref('')
const selectedCampus = ref('')
const isSubmitting = ref(false)
const successMessage = ref('')
const errorMessage = ref('')

const handleSubmit = async (event) => {
  event.preventDefault()
  
  errorMessage.value = ''
  successMessage.value = ''
  isSubmitting.value = true
  
  try {
    // Simulação de chamada de API
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    successMessage.value = 'Usuário cadastrado com sucesso!'
    
    // Limpar formulário após sucesso
    setTimeout(() => {
      router.push('/administrador/usuarios/listar')
    }, 2000)
    
  } catch (error) {
    errorMessage.value = 'Erro ao cadastrar usuário. Tente novamente.'
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
      <!-- Sidebar -->
      <Sidebar :activePage="'usuarios'" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">Cadastrar Novo Usuário</h1>

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

        <form @submit="handleSubmit" class="space-y-6">
          <div class="p-1 rounded-lg shadow-sm">
            <Card customClass="mb-4" title="Dados Pessoais">
              <div class="grid grid-cols-6 gap-6 mb-6 p-1">
                <div class="col-span-4">
                  <Input
                    id="user"
                    name="user"
                    label="Nome Completo*"
                    v-model="user"
                    placeholder="Nome completo do usuário"
                    required
                  />
                </div>
                <div class="col-span-1">
                  Foto de Perfil
                  <img src="/placeholder.svg?height=48&width=48" width="150" alt="" srcset="">
                </div>
                <div class="col-span-1">
                  <Button customClass="mt-20 w-full bg-green-600 hover:bg-green-700 focus:ring-green-500">
                      <i class="fa-solid fa-edit"></i>
                    Selecionar foto
                  </Button>
                </div>
              </div>
            </Card>
            <Card customClass="mb-4" title="Dados institucionais">
              <div class="grid grid-cols-6 gap-6 mb-6 p-1">
                <div class="col-span-2">
                  <Input
                    id="email"
                    name="email"
                    label="Email Institucional*"
                    v-model="user"
                    placeholder="email@ifms.edu.br"
                    required
                  />
                </div>
                <div class="col-span-2">
                  <Input
                    id="siape"
                    name="siape"
                    label="SIAPE*"
                    v-model="user"
                    placeholder="Número SIAPE"
                    required
                  />
                </div>
                <div class="col-span-2">
                    <Select
                      id="campus"
                      name="campus"
                      label="Campus"
                      v-model="selectedCampus"
                      :options="[
                        { value: '', label: 'Selecione um campus' },
                        { value: 'nova_andradina', label: 'Nova Andradina' },
                        { value: 'campo_grande', label: 'Campo Grande' },
                        { value: 'tres_lagoas', label: 'Três Lagoas' }
                      ]"
                    />
                </div>
              </div>
            </Card>
            <Card title="Dados de Acesso">
              <div class="grid grid-cols-6 gap-6 p-1">
                <div class="col-span-2">
                  <Input
                    id="username"
                    name="username"
                    label="Nome de Usuário*"
                    v-model="user"
                    placeholder="nome.usuario"
                    required
                  />
                </div>
                <div class="col-span-2">
                  <Input
                    id="password"
                    name="password"
                    type="password"
                    label="Senha*"
                    v-model="user"
                    placeholder="••••••••"
                    required
                  />
                </div>
                <div class="col-span-2 mt-3">
                  <Input
                    id="confirmPassword"
                    type="password"
                    name="confirmPassword"
                    label="Confirmar senha*"
                    v-model="user"
                    placeholder="••••••••"
                    required
                  />
                </div>
              </div>

              <div class="grid grid-cols-8 gap-2 mt-4">
                <div class="col-span-1">
                  <input type="checkbox" name="admin" />
                  Administrador? 
                </div>  
                <div class="col-span-1">
                  <input type="checkbox" name="active" />
                  Usuário ativo? 
                </div>  
              </div>
            </Card>
          </div>
          <div class="flex justify-end space-x-3">
            <Button 
              variant="secondary"
              to="/administrador/usuarios/listar"
            >
              <i class="fa-solid fa-times mr-2"></i>
              Cancelar
            </Button>
            <Button 
              type="submit"
              variant="success"
              :loading="isSubmitting"
              :disabled="isSubmitting"
            >
              <i v-if="!isSubmitting" class="fa-solid fa-save mr-2"></i>
              {{ isSubmitting ? 'Cadastrando...' : 'Cadastrar usuário' }}
            </Button>
          </div>
        </form>
      </main>
    </div>
  </div>
</template>
