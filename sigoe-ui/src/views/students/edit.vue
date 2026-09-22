<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Header from '@/components/header.vue'
import { find as findStudent, update as updateStudent } from '@/services/students'
import { success, error } from '@/utils/sweetPopup2'

const route = useRoute()
const router = useRouter()
const studentId = ref(route.params.id)

const breadcrumbItems = [
  { label: 'Home', href: '/home' },
  { label: 'Administrador', href: '/administrador' },
  { label: 'Estudantes', href: '/administrador/estudantes/listar' },
  { label: 'Editar', href: `/administrador/estudantes/editar/${studentId.value}` }
]

const student = ref({
  id: studentId.value,
  name: '',
  cpf: '',
  birthdate: '',
  password: '',
  confirmPassword: '',
  responsible: '',
  contact: ''
})

const isLoading = ref(false)
const isSubmitting = ref(false)

const loadStudent = async () => {
  isLoading.value = true

  try {
    const response = await findStudent(studentId.value)
    const data = response?.student

    if (!data) {
      error('Não foi possível carregar os dados do estudante.')
      return
    }

    student.value = {
      id: data.id,
      name: data.name || '',
      cpf: data.cpf || '',
      birthdate: data.birth_date || '',
      password: '',
      confirmPassword: '',
      responsible: data.responsible || data.responsible_contact || '',
      contact: data.contact || ''
    }
  } catch (e) {
    error(e.response?.data?.errors?.join(', ') || 'Não foi possível carregar os dados do estudante.')
  } finally {
    isLoading.value = false
  }
}

const handleSubmit = async (event) => {
  event.preventDefault()

  if (student.value.password && student.value.password !== student.value.confirmPassword) {
    error('As senhas não coincidem.')
    return
  }

  isSubmitting.value = true

  const payload = {
    name: student.value.name,
    cpf: student.value.cpf,
    birth_date: student.value.birthdate,
    responsible: student.value.responsible,
    contact: student.value.contact,
    password: student.value.password,
    password_confirmation: student.value.confirmPassword
  }

  try {
    await updateStudent(student.value.id, payload)
    if (await success('Dados do estudante atualizados com sucesso!')){
      router.push(`/administrador/estudantes/visualizar/${student.value.id}`)
    }
  } catch (e) {
    error(e.response?.data?.errors?.join(', ') || 'Erro ao atualizar dados do estudante. Tente novamente.')
  } finally {
    isSubmitting.value = false
  }
}

onMounted(loadStudent)
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'estudantes'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">Editar estudante</h1>

        <div v-if="isLoading" class="bg-white rounded-lg shadow-sm p-6 text-center">
          Carregando estudante...
        </div>

        <form v-else @submit="handleSubmit" class="space-y-6">
          <Card customClass="mb-4">
            <div class="border-b border-gray-200 pb-2 mb-4">
              <h2 class="text-sm font-medium text-gray-500">Dados pessoais</h2>
            </div>

            <div class="grid grid-cols-1 gap-6 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Nome</label>
                <Input v-model="student.name" type="text" placeholder="Nome completo do estudante" required />
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">CPF</label>
                <Input v-model="student.cpf" type="text" placeholder="000.000.000-00" required />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Data de Nascimento</label>
                <Input v-model="student.birthdate" type="date" required />
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Senha para assinatura digital</label>
                <Input v-model="student.password" type="password" placeholder="••••••••" />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Confirmar senha</label>
                <Input v-model="student.confirmPassword" type="password" placeholder="••••••••" />
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
                <Input v-model="student.responsible" type="text" placeholder="Responsável" />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Contato</label>
                <Input v-model="student.contact" type="text" placeholder="Email / Telefone" />
              </div>
            </div>
          </Card>

          <div class="flex justify-start space-x-3">
            <Button variant="secondary" :to="`/administrador/estudantes/visualizar/${student.id}`">
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