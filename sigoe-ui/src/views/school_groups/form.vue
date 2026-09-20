<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Header from '@/components/header.vue'
import Sidebar from '@/components/sidebar.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Button from '@/components/ui/button.vue'
import { find, create, update } from '@/services/school_groups'
import { can } from '@/services/permissions'
import { confirm, error, success } from '@/utils/sweetPopup2'

const route = useRoute()
const router = useRouter()
const editing = !!route.params.id
const form = ref({ name: '', identifier: '' })

onMounted(async () => {
  if (editing) {
    form.value = await find(route.params.id)
  }
})

const save = async () => {
  try {
    if (editing) {
      await update(route.params.id, form.value)
      success("Turma atualizada com sucesso")
    } else {
      await create(form.value)
      success("Turma criada com sucesso")
    }

    router.push('/administrador/turmas/listar')
  } catch (e) {
    error(e.response?.data?.errors?.join(', ') || 'Não foi possível salvar')
  }
}
</script>

<template>
  <div class="min-h-screen">
    <Header />

    <div class="flex flex-col md:flex-row">
      <Sidebar activePage="turmas" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="[{ label: 'Home', href: '/home' }, { label: 'Administrador' }, { label: 'Turmas', href: '/administrador/turmas/listar' }, { label: editing ? 'Editar turma' : 'Nova turma' }]" />

        <h1 class="text-2xl font-bold mb-6">
          {{ editing ? 'Editar turma' : 'Nova turma' }}
        </h1>

        <Card title="Dados da turma">

          <div class="grid md:grid-cols-2 gap-4">
            <Input v-model="form.name" label="Nome" />
            <Input v-model="form.identifier" label="Identificador" />
          </div>

          <div class="flex gap-2 mt-6">
            <Button :disabled="editing ? !can('classes', 'update') : !can('classes', 'create')" @click="save" customClass="bg-green-600">
              Salvar
            </Button>

            <Button to="/administrador/turmas/listar" customClass="bg-gray-500">
              Cancelar
            </Button>
          </div>
        </Card>
      </main>
    </div>
  </div>
</template>