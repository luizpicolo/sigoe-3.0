<script setup>
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Input from '@/components/ui/input.vue'
import { ref } from 'vue'
import { can } from '@/services/permissions'
import VPagination from "@hennge/vue3-pagination";
import "@hennge/vue3-pagination/dist/vue3-pagination.css";

const breadcrumbItems = [{ label: "Home", href: "/" }, { label: "Administrador", href: "/" }, { label: "Ocorrências", href: "/ocorrencias/ocorrencias/listar" }];
const page = ref(1);
const updateHandler = (newPage) => { page.value = newPage; };
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center"><div class="flex items-center"><img src="/logo_ifms.png" width="160"></div><div class="text-sm">SIGOE - Controle de ocorrências escolares - <span class="text-green-600">Sair</span></div></header>
    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'ocorrencias'" />
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <h1 class="text-2xl font-bold mb-6">Ocorrências Escolares</h1>
        <div class="bg-white rounded-md shadow p-4 mb-6"><div class="flex flex-wrap gap-2">
          <Button v-if="can('occurrences', 'create')" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500" to="/ocorrencias/ocorrencias/novo"><i class="fa-solid fa-user"></i>Nova Ocorrência</Button>
          <div class="flex items-center gap-2 ml-auto"><span class="text-sm">Ordenar por</span><select class="block w-[180px] px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm"><option>Nome</option><option>Curso</option><option>Turma</option></select></div>
          <div class="flex items-center gap-2"><span class="text-sm">Total</span><select class="block w-[80px] px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm"><option>10</option><option>25</option><option>50</option><option>100</option></select></div>
          <div class="flex items-center gap-2"><Input type="text" placeholder="Buscar..." class="w-[200px]" /><Button customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500"><i class="fa-solid fa-magnifying-glass"></i>Busca</Button></div>
        </div></div>
        <div class="bg-white rounded-md shadow overflow-hidden"><table class="min-w-full divide-y divide-gray-200"><thead class="bg-gray-100"><tr><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">ID</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Data</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Estudante</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Curso</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Campus</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Visibilidade</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Verificado?</th><th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Ações</th></tr></thead>
          <tbody v-for="i in 10" :key="i" class="bg-white divide-y divide-gray-200"><tr><td class="px-6 py-4 text-sm font-medium text-gray-900">{{ i }}</td><td class="px-6 py-4 text-sm text-gray-500">30/04/2025</td><td class="px-6 py-4 text-sm text-gray-500">Luiz Fernando Picolo</td><td class="px-6 py-4 text-sm text-gray-500">Curso Técnico em Informática</td><td class="px-6 py-4 text-sm text-gray-500">Nova Andradina</td><td class="px-6 py-4 text-center text-sm text-gray-500"><i class="fa-solid fa-check text-green-600"></i></td><td class="px-6 py-4 text-center text-sm text-gray-500"><i class="fa-solid fa-check text-green-600"></i></td><td class="px-6 py-4 text-sm text-gray-500"><Button customClass="w-full bg-green-600 hover:bg-green-700 focus:ring-green-500" :to="`/ocorrencias/ocorrencias/visualizar/${i}`"><i class="fa-solid fa-eye"></i>Visualizar</Button></td></tr></tbody>
        </table><div class="flex justify-end items-end p-4"><VPagination v-model="page" :pages="100" :range-size="2" active-color="#00a63e" @update:modelValue="updateHandler" /></div></div>
      </main>
    </div>
  </div>
</template>
