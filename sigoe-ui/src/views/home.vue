<script setup>
import Sidebar from '@/components/sidebar.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Header from '@/components/header.vue'

const breadcrumbItems = [
  { label: 'Home', href: "/" }
];
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <!-- Header -->
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <!-- Sidebar -->
      <Sidebar :activePage="''" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <div class="mb-6 bg-green-50 border border-green-200 rounded-md p-4 flex items-start">
          <svg class="text-green-600 mr-3 mt-0.5 h-5 w-5 flex-shrink-0" xmlns="http://www.w3.org/2000/svg" fill="none"
            viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M12 8v4m0 4h.01M12 2a10 10 0 100 20 10 10 0 000-20z" />
          </svg>
          <div>
            <p class="text-green-800">
              Olá prezado(a) servidor(a), seja bem vindo(a) ao SIGOE (Sistema para o controle de ocorrências
              escolares). Atualmente o sistema não é mantido pela DIRTI. Por este motivo, pedimos a gentileza de
              entrar em contato com o administrador local. Caso a solicitação seja para solução de problemas ou pedido
              de novas funcionalidades, entre em contato com o administrador geral luiz.picolo@ifms.edu.br.
            </p>
          </div>
        </div>

        <h1 class="text-2xl font-bold mb-6">Dashboard</h1>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-2 gap-6 mb-6 p-4 rounded-lg shadow-sm">
          <Card title="Card 1" description="Aqui será um diagrama" />
          <Card title="Card 2" description="Aqui será um diagrama" />
          <Card title="Card 3" description="Aqui será um diagrama" />
          <Card title="Card 4" description="Aqui será um diagrama" />
        </div>
      </main>
    </div>
  </div>
</template>