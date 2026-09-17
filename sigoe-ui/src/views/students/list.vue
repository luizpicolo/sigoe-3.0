<script setup>
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Input from '@/components/ui/input.vue'
import { onMounted, ref } from 'vue'
import { list } from '@/services/students'

import VPagination from "@hennge/vue3-pagination";
import "@hennge/vue3-pagination/dist/vue3-pagination.css";

const breadcrumbItems = [
  { label: "Home", href: "/" },
  { label: "Administrador", href: "/" },
  { label: "Estudantes", href: "/administrador/estudantes/listar" },
];

const page = ref(1);
const amount = ref(10);
const order = ref('id');
const search = ref('');
const students = ref([]);
const total = ref(0);
const loading = ref(false);

const loadStudents = async () => {
  loading.value = true;
  const response = await list(page.value, order.value, search.value, amount.value);
  students.value = response?.students || [];
  total.value = response?.total || 0;
  loading.value = false;
};

const updateHandler = (newPage) => {
  page.value = newPage;
  loadStudents();
};

const searchStudents = () => {
  page.value = 1;
  loadStudents();
};

const changeFilters = () => {
  page.value = 1;
  loadStudents();
};

onMounted(loadStudents);
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center">
      <div class="flex items-center">
        <img src="/logo_ifms.png" width="160">
      </div>
      <div class="text-sm">
        SIGOE - Controle de ocorrências escolares - <span class="text-green-600">Sair</span>
      </div>
    </header>

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'estudantes'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <h1 class="text-2xl font-bold mb-6">Estudantes</h1>

        <div class="bg-white rounded-md shadow p-4 mb-6">
          <div class="flex flex-wrap gap-2">
            <Button customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500" to="/administrador/usuarios/novo">
              <i class="fa-solid fa-user"></i>
              Novo Estudante
            </Button>

            <div class="flex items-center gap-2 ml-auto">
              <span class="text-sm">Ordenar por</span>
              <select v-model="order" @change="changeFilters" class="block w-[180px] px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm sm:text-sm">
                <option value="id">ID</option>
                <option value="name">Nome</option>
              </select>
            </div>

            <div class="flex items-center gap-2">
              <span class="text-sm">Total</span>
              <select v-model="amount" @change="changeFilters" class="block w-[80px] px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm sm:text-sm">
                <option :value="10">10</option>
                <option :value="25">25</option>
                <option :value="50">50</option>
                <option :value="100">100</option>
              </select>
            </div>

            <div class="flex items-center gap-2">
              <Input v-model="search" type="text" placeholder="Buscar..." class="w-[200px]" />
              <Button @click="searchStudents" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500">
                <i class="fa-solid fa-magnifying-glass"></i>
                Busca
              </Button>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-md shadow overflow-hidden">
          <div v-if="loading" class="p-6 text-center">Carregando estudantes...</div>
          <table v-else class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-100">
              <tr>
                <th v-for="heading in ['ID', 'Foto', 'Nome', 'Campus', 'Turma', 'Polo', 'Ações']" :key="heading" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  {{ heading }}
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <tr v-for="student in students" :key="student.id">
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ student.id }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  <img :src="student.photo || '/placeholder.svg'" width="100" alt="Foto do estudante">
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ student.name }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ student.course?.name || '-' }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ student.enrollment || '-' }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ student.school_group?.name || '-' }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  <Button customClass="w-full bg-green-600 hover:bg-green-700 focus:ring-green-500" :to="`/administrador/estudantes/visualizar/${student.id}`">
                    <i class="fa-solid fa-eye"></i>
                    Visualizar
                  </Button>
                </td>
              </tr>
              <tr v-if="!students.length">
                <td colspan="7" class="px-6 py-4 text-center text-sm text-gray-500">Nenhum estudante encontrado.</td>
              </tr>
            </tbody>
          </table>

          <div class="flex justify-end items-end p-4">
            <VPagination v-model="page" :pages="Math.max(1, Math.ceil(total / amount))" :range-size="2" active-color="#00a63e" @update:modelValue="updateHandler" />
          </div>
        </div>
      </main>
    </div>
  </div>
</template>
