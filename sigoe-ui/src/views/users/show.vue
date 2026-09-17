<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'

import { find } from '@/services/users'
import { formatDate, avatar } from '@/utils'

const breadcrumbItems = [
  { label: "Home", href: "/" },
  { label: "Administrador", href: "/administrador" },
  { label: "Usuários", href: "/administrador/usuarios" },
  { label: "Visualizar", href: "/administrador/usuarios/visualizar" },
];

const route = useRoute()
const userId = ref(route.params.id)
const user = ref("")

onMounted(() => {
  fetchUser(userId)
})

const fetchUser = async (userId) => {
  const response = await find(userId)
  user.value = response.user
}
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center">
      <div class="flex items-center">
        <img src="/logo_ifms.png" width="160">
      </div>
      <div class="text-sm">
        SIGOE - Controle de ocorrências escolares - <span class="text-green-600">Sair</span>
      </div>
    </header>

    <div class="flex flex-col md:flex-row flex-1">
      <!-- Sidebar -->
      <Sidebar :activePage="'usuarios'" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-1">Detalhes do Usuário</h1>

        <div class="flex justify-end">
          <Button to="/administrador/usuarios/listar" customClass="bg-white border-gray-200 !text-gray-900 hover:bg-gray-100 !focus:ring-gray-300">
            <i class="fa-solid fa-arrow-left"></i>
            Voltar
          </Button>
        </div>

        <div class="grid grid-cols-4 gap-4 mb-6 mt-4 rounded-lg shadow-sm">
          <Card customClass="col-span-1 " title="Foto">
            <div class="flex justify-center items-center mt-5 pt-2 pb-5">
              <img :src="avatar(user?.avatar?.url)" width="200" alt="" srcset="">
            </div>
          </Card>
          <Card customClass="col-span-3" title="Informações Pessoais">
            <dl class="divide-y divide-gray-200">
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Nome completo</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ user.name }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Email</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ user.email }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">SIAPE</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ user.siape }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Campus</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ user.polo?.name }}</dd>
              </div>
            </dl>
          </Card>
          <Card customClass="col-span-1" title="Ações">
            <Button variant="info" to="/administrador/usuarios/permissoes/9" customClass="w-full">
                <i class="fa-solid fa-edit"></i>
              Gerenciar Permissões
            </Button>
            <Button to="" customClass="mt-4 w-full">
              <i class="fa-solid fa-edit"></i>
              Editar Usuário
            </Button>
            <Button to="" variant="danger" customClass="mt-4 w-full">
              <i class="fa-solid fa-trash-alt"></i>
              Excluir Usuário
            </Button>
          </Card>
          <Card customClass="col-span-3" title="Informações de Acesso" description="Aqui será um diagrama">
            <dl class="divide-y divide-gray-200">
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Nome de usuário</dt>
                <dd class="text-sm text-gray-900 col-span-2">{{ user.username }}</dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Administrador</dt>
                <dd class="text-sm text-gray-900 col-span-2">
                  <span
                    v-if="user.admin"
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                    Ativo
                  </span>
                  <span
                    v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                    Não
                  </span>
                </dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Status</dt>
                <dd class="text-sm text-gray-900 col-span-2">
                  <span
                    v-if="user.status"
                    class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                    Ativo
                  </span>
                  <span
                    v-else class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800">
                    Não
                  </span>
                </dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Data de criação</dt>
                <dd class="text-sm text-gray-900 col-span-2">
                  {{ formatDate(user.created_at) }}
                </dd>
              </div>
              <div class="py-3 grid grid-cols-3">
                <dt class="text-sm font-medium text-gray-500">Último acesso</dt>
                <dd class="text-sm text-gray-900 col-span-2">
                  {{ formatDate(user.updated_at) }}
                </dd>
              </div>
            </dl>
          </Card>
        </div>
      </main>
    </div>
  </div>
</template>