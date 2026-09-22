<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Header from '@/components/header.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Button from '@/components/ui/button.vue'

import { find, create, update } from '@/services/courses'
import { can } from '@/services/permissions'
import { success, error, confirm } from '@/utils/sweetPopup2'

const route = useRoute()
const router = useRouter()
const editing = !!route.params.id

const form = ref({
  name: '',
  initial: ''
})

onMounted(async () => {
  if (!editing) return

  try {
    form.value = await find(route.params.id)
  } catch (e) {
    error(e.response?.data?.errors?.join(', ') || 'Não foi possível carregar os dados do curso.')
  }
})

const save = async () => {
  const payload = {
    name: form.value.name,
    initial: form.value.initial,
    polo_id: form.value.polo_id
  }

  try {
    if (editing) {
      await update(route.params.id, payload)
    } else {
      await create(form.value)
    }

    if (await success('Curso salvo com sucesso')) {
      await router.push('/administrador/cursos/listar')
    }
  } catch (e) {
    error(e.response?.data?.errors?.join(', ') || 'Não foi possível salvar o curso.')
  }
}
</script>

<template>
  <div class="min-h-screen">
    <Header />

    <div class="flex flex-col md:flex-row">
      <Sidebar activePage="cursos" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="[{ label: 'Home', href: '/home' }, { label: 'Administrador' }, { label: 'Cursos', href: '/administrador/cursos/listar' }, { label: editing ? 'Editar curso' : 'Novo curso' }]" />

        <h1 class="text-2xl font-bold mb-6">
          {{ editing ? 'Editar curso' : 'Novo curso' }}
        </h1>

        <Card title="Dados do curso">
          <div class="grid md:grid-cols-2 gap-4">
            <Input v-model="form.name" label="Nome" />
            <Input v-model="form.initial" label="Sigla" />
          </div>

          <div class="flex gap-2 mt-6">
            <Button to="/administrador/cursos/listar" customClass="bg-white border-gray-200 !text-gray-900">
              <i class="fa-solid fa-times pr-2"></i>
              Cancelar
            </Button>

            <Button :disabled="editing ? !can('courses', 'update') : !can('courses', 'create')" @click="save" customClass="bg-green-600 hover:bg-green-700">
              <i class="fa-solid fa-save pr-2"></i>
              Salvar
            </Button>
          </div>
        </Card>
      </main>
    </div>
  </div>
</template>