<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Alert from '@/components/ui/alert.vue'
import Header from '@/components/header.vue'
import { create as createStudent, options as studentOptions } from '@/services/students'

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
  ra: "",
  enrollment: "",
  courseSituation: "Em curso",
  courseId: "",
  schoolGroupId: "",
  password: "",
  confirmPassword: "",
  responsible: "",
  contact: ""
})

const courses = ref([])
const schoolGroups = ref([])
const courseSituations = ref([])
const isLoading = ref(false)
const isSubmitting = ref(false)
const errorMessage = ref('')

const loadOptions = async () => {
  isLoading.value = true
  errorMessage.value = ''

  try {
    const response = await studentOptions()
    courses.value = response?.courses || []
    schoolGroups.value = response?.school_groups || []
    courseSituations.value = response?.course_situations || []
  } catch (error) {
    errorMessage.value = 'Não foi possível carregar os dados para o cadastro.'
  } finally {
    isLoading.value = false
  }
}

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
    ra: student.value.ra,
    enrollment: student.value.enrollment,
    course_situation: student.value.courseSituation,
    course_id: student.value.courseId,
    school_group_id: student.value.schoolGroupId,
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

onMounted(loadOptions)
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

        <div v-if="isLoading" class="bg-white rounded-lg shadow-sm p-6 text-center">
          Carregando dados...
        </div>

        <form v-else @submit="handleSubmit" class="space-y-6">
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

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">RA</label>
                <Input
                  v-model="student.ra"
                  type="number"
                  placeholder="Registro acadêmico"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Matrícula</label>
                <Input
                  v-model="student.enrollment"
                  type="text"
                  placeholder="Número da matrícula"
                  required
                />
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Curso</label>
                <select
                  v-model="student.courseId"
                  class="w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm text-gray-700 focus:border-green-500 focus:outline-none focus:ring-green-500"
                  required
                >
                  <option value="" disabled>Selecione o curso</option>
                  <option v-for="course in courses" :key="course.id" :value="course.id">
                    {{ course.name }}{{ course.initial ? ` (${course.initial})` : '' }}
                  </option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Turma</label>
                <select
                  v-model="student.schoolGroupId"
                  class="w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm text-gray-700 focus:border-green-500 focus:outline-none focus:ring-green-500"
                  required
                >
                  <option value="" disabled>Selecione a turma</option>
                  <option v-for="schoolGroup in schoolGroups" :key="schoolGroup.id" :value="schoolGroup.id">
                    {{ schoolGroup.identifier || schoolGroup.name }}
                  </option>
                </select>
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Situação</label>
                <select
                  v-model="student.courseSituation"
                  class="w-full rounded-md border border-gray-300 bg-white px-3 py-2 text-sm text-gray-700 focus:border-green-500 focus:outline-none focus:ring-green-500"
                  required
                >
                  <option v-for="situation in courseSituations" :key="situation" :value="situation">
                    {{ situation }}
                  </option>
                </select>
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

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
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
