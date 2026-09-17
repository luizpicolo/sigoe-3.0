<template>
  <main class="min-h-screen flex items-center justify-center bg-gray-50 p-6">
    <section class="max-w-lg w-full bg-white rounded-lg shadow-sm border border-gray-200 p-8 text-center">
      <i class="fa-solid fa-lock text-4xl text-gray-400 mb-4"></i>
      <h1 class="text-2xl font-bold text-gray-900 mb-2">Acesso não permitido</h1>
      <p class="text-gray-600 mb-6">
        Seu usuário não possui permissão para visualizar ou executar esta funcionalidade.
      </p>
      <router-link
        to="/home"
        class="inline-flex items-center px-4 py-2 rounded-md bg-green-600 text-white hover:bg-green-700"
      >
        Voltar para o início
      </router-link>
    </section>
  </main>
</template>
