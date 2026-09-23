<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Header from '@/components/header.vue'
import { find, remove } from '@/services/users'
import { can } from '@/services/permissions'
import { formatDate, avatar } from '@/utils'
import { error, confirm, success } from '@/utils/sweetPopup2'

const breadcrumbItems = [
  { label: 'Home', href: '/' },
  { label: 'Administrador', href: '/administrador' },
  { label: 'Usuários', href: '/administrador/usuarios' },
  { label: 'Visualizar', href: '/administrador/usuarios/visualizar' }
]

const route = useRoute()
const router = useRouter()
const userId = ref(route.params.id)
const user = ref(null)
const loading = ref(false)

const fetchUser = async id => {
  loading.value = true

  try {
    const response = await find(id)

    user.value = response?.user || null
  } catch (e) {
    error(e.response?.data?.error || e.response?.data?.errors?.join(', ') || 'Não foi possível carregar o usuário.')
  } finally {
    loading.value = false
  }
}

const deleteUser = async () => {
  if (!await confirm('Deseja realmente excluir este usuário?')) {
    return
  }

  try {
    await remove(userId.value)

    if (await success('Usuário excluído com sucesso!')){
      await router.push('/administrador/usuarios/listar')
    }
  } catch (e) {
    error(e.response?.data?.error || e.response?.data?.errors?.join(', ') || 'Não foi possível excluir o usuário.')
  }
}

onMounted(() => fetchUser(userId.value))
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'usuarios'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <div class="flex items-center justify-between mb-6">
          <div>
            <h1 class="text-2xl font-bold">
              Detalhes do Usuário
            </h1>
          </div>

          <Button to="/administrador/usuarios/listar" customClass="bg-white border-gray-200 !text-gray-900 hover:bg-gray-100 !focus:ring-gray-300">
            <i class="fa-solid fa-arrow-left pr-2"></i>
            Voltar
          </Button>
        </div>

        <div v-if="loading" class="py-8 text-center text-gray-600">
          Carregando informações do usuário...
        </div>

        <div v-else-if="user" class="grid grid-cols-4 gap-4 mb-6 rounded-lg shadow-sm">
          <Card customClass="col-span-1" title="Foto">
            <div class="flex justify-center items-center mt-5 pt-2 pb-5">
              <img :src="avatar(user?.avatar?.url)" class="h-24 w-24 rounded-full object-cover" alt="Foto do usuário" />
            </div>
          </Card>

          <Card customClass="col-span-3" title="Informações Pessoais">
            <dl class="divide-y divide-gray-200">
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">
                  Nome completo
                </dt>

                <dd class="text-sm text-gray-900 col-span-2">
                  {{ user.name }}
                </dd>
              </div>

              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">
                  Email
                </dt>

                <dd class="text-sm text-gray-900 col-span-2">
                  {{ user.email }}
                </dd>
              </div>

              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">
                  SIAPE
                </dt>

                <dd class="text-sm text-gray-900 col-span-2">
                  {{ user.siape || '-' }}
                </dd>
              </div>

              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">
                  Campus
                </dt>

                <dd class="text-sm text-gray-900 col-span-2">
                  {{ user.polo?.name || '-' }}
                </dd>
              </div>
            </dl>
          </Card>

          <Card customClass="col-span-1" title="Ações">
            <Button :disabled="!can('users', 'update')" variant="info" :to="`/administrador/usuarios/visualizar/${userId}/permissoes`" customClass="w-full">
              <i class="fa-solid fa-shield-halved pr-2"></i>
              Gerenciar Permissões
            </Button>

            <Button :disabled="!can('users', 'update')" :to="`/administrador/usuarios/editar/${userId}`" customClass="mt-4 w-full">
              <i class="fa-solid fa-edit pr-2"></i>
              Editar Usuário
            </Button>

            <Button :disabled="!can('users', 'destroy')" variant="danger" @click="deleteUser" customClass="mt-4 w-full">
              <i class="fa-solid fa-trash-alt pr-2"></i>
              Excluir Usuário
            </Button>
          </Card>

          <Card customClass="col-span-3" title="Informações de Acesso" description="Aqui será um diagrama">
            <dl class="divide-y divide-gray-200">
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">
                  Nome de usuário
                </dt>

                <dd class="text-sm text-gray-900 col-span-2">
                  {{ user.username }}
                </dd>
              </div>

              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">
                  Administrador
                </dt>

                <dd class="text-sm text-gray-900 col-span-2">
                  <span v-if="user.admin" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                    Ativo
                  </span>

                  <span v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                    Não
                  </span>
                </dd>
              </div>

              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">
                  Status
                </dt>

                <dd class="text-sm text-gray-900 col-span-2">
                  <span v-if="user.status" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                    Ativo
                  </span>

                  <span v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                    Não
                  </span>
                </dd>
              </div>

              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">
                  Data de criação
                </dt>

                <dd class="text-sm text-gray-900 col-span-2">
                  {{ formatDate(user.created_at) }}
                </dd>
              </div>

              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">
                  Último acesso
                </dt>

                <dd class="text-sm text-gray-900 col-span-2">
                  {{ formatDate(user.updated_at) }}
                </dd>
              </div>
            </dl>
          </Card>
        </div>

        <div v-else class="py-8 text-center text-gray-500">
          Não foi possível encontrar o usuário.
        </div>
      </main>
    </div>
  </div>
</template>