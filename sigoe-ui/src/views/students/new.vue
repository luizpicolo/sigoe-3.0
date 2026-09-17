<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Alert from '@/components/ui/alert.vue'
import Header from '@/components/header.vue'
import { create as createStudent } from '@/services/students'

const router = useRouter()

const breadcrumbItems = [
  { label: "Home", href: "/home" },
  { label: "Administrador", href: "/administrador" },
  { label: "Estudantes", href: "/administrador/estudantes/listar" },
  { label: "Novo estudante", href: "/administrador/estudantes/novo" },
];

const student = ref({
  name: "",
  cpf: "",
  birthdate: "",
  password: "",
  confirmPassword: "",
  responsible: "",
  contact: ""
})

const isSubmitting = ref(false)
const errorMessage = ref('')

const handleSubmit = async (event) => {
  event.preventDefault()
  errorMessage.value = ''

  if (student.value.password !== student.value.confirmPassword) {
    errorMessage.value = 'As senhas não coincidem.'
    return
  }

  isSubmitting.value = true

  const response = await createStudent({
    name: student.value.name,
    cpf: student.value.cpf,
    birth_date: student.value.birthdate,
    password: student.value.password,
    password_confirmation: student.value.confirmPassword,
    responsible: student.value.responsible,
    contact: student.value.contact
  })

  if (response?.student) {
    await router.push(`/administrador/estudantes/visualizar/${response.student.id}`)
  } else {
    errorMessage.value = Array.isArray(response?.error)
      ? response.error.join(', ')
      : 'Erro ao cadastrar estudante. Tente novamente.'
  }

  isSubmitting.value = false
}

const dismissError = () => {
  errorMessage.value = ''
}
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'estudantes'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">Novo estudante</h1>

        <Alert
          v-if="errorMessage"
          type="error"
          :message="errorMessage"
          dismissible
          @dismiss="dismissError"
          class="mb-4"
        />

        <form @submit="handleSubmit" class="space-y-6">
          <Card customClass="mb-4">
            <div class="border-b border-gray-200 pb-2 mb-4">
              <h2 class="text-sm font-medium text-gray-500">Dados pessoais</h2>
            </div>

            <div class="grid grid-cols-1 gap-6 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Nome</label>
                <Input
                  v-model="student.name"
                  type="text"
                  placeholder="Nome completo do estudante"
                  required
                />
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">CPF</label>
                <Input
                  v-model="student.cpf"
                  type="text"
                  placeholder="000.000.000-00"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Data de Nascimento</label>
                <Input
                  v-model="student.birthdate"
                  type="date"
                  required
                />
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Senha para assinatura digital</label>
                <Input
                  v-model="student.password"
                  type="password"
                  placeholder="••••••••"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Confirmar senha</label>
                <Input
                  v-model="student.confirmPassword"
                  type="password"
                  placeholder="••••••••"
                  required
                />
              </div>
            </div>
          </Card>

          <Card customClass="mb-4">
            <div class="border-b border-gray-200 pb-2 mb-4">
              <h2 class="text-sm font-medium text-gray-500">Dados responsável</h2>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Responsável</label>
                <Input
                  v-model="student.responsible"
                  type="text"
                  placeholder="Responsável"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Contato</label>
                <Input
                  v-model="student.contact"
                  type="text"
                  placeholder="Email / Telefone"
                />
              </div>
            </div>
          </Card>

          <div class="flex justify-start space-x-3">
            <Button
              variant="secondary"
              to="/administrador/estudantes/listar"
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
              {{ isSubmitting ? 'Salvando...' : 'Salvar' }}
            </Button>
          </div>
        </form>
      </main>
    </div>
  </div>
</template>
