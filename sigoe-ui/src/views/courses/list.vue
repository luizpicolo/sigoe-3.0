<script setup>
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Input from '@/components/ui/input.vue'
import { ref } from 'vue'

// https://github.com/HENNGE/vue3-pagination
import VPagination from "@hennge/vue3-pagination";
import "@hennge/vue3-pagination/dist/vue3-pagination.css";


const breadcrumbItems = [
  { label: "Home", href: "/" },
  { label: "Administrador", href: "/" },
  { label: "Estudantes", href: "/administrador/usuarios/listar" },
];

const page = ref(1);
const updateHandler = (newPage) => {
  page.value = newPage;
  console.log(`Page updated to: ${newPage}`);
};
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
      <Sidebar :activePage="'cursos'" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">Cursos</h1>

        <div class="bg-white rounded-md shadow p-4 mb-6">
          <div class="flex flex-wrap gap-2">
          <Button 
            customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500"
            to="/administrador/usuarios/novo"
          >
            <i class="fa-solid fa-user"></i>
            Novo curso
          </Button>

            <div class="flex items-center gap-2 ml-auto">
              <span class="text-sm">Ordenar por</span>
              <div class="relative w-[180px]">
                <select
                  class="block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm">
                  <option value="name">Nome</option>
                  <option value="course">Curso</option>
                  <option value="class">Turma</option>
                </select>
              </div>
            </div>

            <div class="flex items-center gap-2">
              <span class="text-sm">Total</span>
              <div class="relative w-[80px]">
                <select
                  class="block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm">
                  <option value="10">10</option>
                  <option value="25">25</option>
                  <option value="50">50</option>
                  <option value="100">100</option>
                </select>
              </div>
            </div>

            <div class="flex items-center gap-2">
              <Input type="text" placeholder="Buscar..." class="w-[200px]" />
              <Button customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500">
                <i class="fa-solid fa-magnifying-glass"></i>
                Busca
              </Button>
            </div>
          </div>
        </div>

        <div class="bg-white rounded-md shadow overflow-hidden">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-100">
              <tr>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  ID
                </th>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Nome
                </th>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Campus
                </th>
                <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Ações
                </th>
              </tr>
            </thead>
            <tbody v-for="(value, i) in 5" class="bg-white divide-y divide-gray-200">
              <tr>
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ i }}</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Curso de Extensão Partiu IF</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">Nova Andradina</td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  <Button customClass="w-full bg-green-600 hover:bg-green-700 focus:ring-green-500" to="/administrador/usuarios/visualizar/9">
                    <i class="fa-solid fa-eye"></i>
                    Visualizar
                  </Button>
                </td>
              </tr>
            </tbody>
          </table>

            <div class="flex justify-end items-end p-4">
              <VPagination
                v-model="page"
                :pages="100"
                :range-size="2"
                active-color="#00a63e"
                @update:modelValue="updateHandler"
              />
            </div>
        </div>
      </main>
    </div>
  </div>
</template>