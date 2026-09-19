<script setup>
import { ref, computed, onMounted } from 'vue'
import { list } from '@/services/users'
import { can } from '@/services/permissions'

import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Input from '@/components/ui/input.vue'
import Header from '@/components/header.vue'
import VPagination from '@hennge/vue3-pagination'
import '@hennge/vue3-pagination/dist/vue3-pagination.css'

const users = ref([])
const usersTotal = ref(0)
const page = ref(1)
const orderby = ref('id')
const search = ref('')
const showCampus = computed(() => users.value.some(user => user.super_admin === true))

const breadcrumbItems = [{ label: 'Home', href: '/' }, { label: 'Administrador', href: '/administrador' }, { label: 'Usuários', href: '/administrador/usuarios' }]

onMounted(() => fetchUsers())

const handleOrderBy = event => {
  orderby.value = event.target.value
  fetchUsers()
}

const fetchUsers = async () => {
  const response = await list(page.value, orderby.value, search.value)
  users.value = response.users
  usersTotal.value = response.total
}

const handleSearch = () => {
  page.value = 1
  fetchUsers()
}

const handlerUpdatePagination = newPage => {
  page.value = newPage
  fetchUsers()
}
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />
    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'usuarios'" />
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <h1 class="text-2xl font-bold mb-6">Usuários</h1>
        <div class="bg-white rounded-md shadow p-4 mb-6">
          <div class="flex flex-wrap gap-2">
            <Button :disabled="!can('users', 'create')" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500" to="/administrador/usuarios/novo"><i class="fa-solid fa-user"></i>Novo Usuário</Button>
            <div class="flex items-center gap-2 ml-auto"><span class="text-sm">Ordenar por</span><div class="relative w-[180px]"><select @change.prevent="handleOrderBy" class="block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm"><option value="id">ID</option><option value="name">Nome</option></select></div></div>
            <div class="flex items-center gap-2"><span class="text-sm">Total</span><div class="relative w-[80px]"><select class="block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm"><option value="10">10</option><option value="25">25</option><option value="50">50</option><option value="100">100</option></select></div></div>
            <div class="flex items-center gap-2"><Input v-model="search" type="text" placeholder="Buscar..." class="w-[200px]" @keyup.enter="handleSearch" /><button class="justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-green-600 hover:bg-green-700" @click="handleSearch"><i class="fa-solid fa-magnifying-glass"></i>Busca</button></div>
          </div>
        </div>
        <div class="bg-white rounded-md shadow overflow-hidden">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-100"><tr><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">ID</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nome</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Email</th><th v-if="showCampus" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Campus</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">usuário</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Admin</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Ativo</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Ações</th></tr></thead>
            <tbody><tr v-for="user in users" :key="user.id" class="bg-white divide-y divide-gray-200"><td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ user }}</td><td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ user.name }}</td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ user.email }}</td><td v-if="user.super_admin" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ user.polo?.name || '-' }}</td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ user.username }}</td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><span v-if="user.admin" class="text-green-600"><i class="fa-solid fa-circle-check"></i>Sim</span><span v-else class="text-red-600"><i class="fa-solid fa-circle-xmark"></i>Não</span></td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><span v-if="user.status" class="text-green-600"><i class="fa-solid fa-circle-check"></i>Sim</span><span v-else class="text-red-600"><i class="fa-solid fa-circle-xmark"></i>Não</span></td><td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500"><Button customClass="w-full bg-green-600 hover:bg-green-700 focus:ring-green-500" :to="`/administrador/usuarios/visualizar/${user.id}`"><i class="fa-solid fa-eye"></i>Visualizar</Button></td></tr></tbody>
          </table>
          <div class="flex justify-end items-end p-4"><VPagination v-model="page" :pages="Math.max(1, Math.ceil(usersTotal / 12))" :range-size="2" active-color="#00a63e" @update:modelValue="handlerUpdatePagination" /></div>
        </div>
      </main>
    </div>
  </div>
</template>