<script setup>
import UserProfile from '@/components/userprofile.vue'

defineProps({
  activePage: {
    type: String,
    required: true
  }
});
</script>

<template>
  <aside class="w-full md:w-64 bg-white border-r border-gray-200">
    <!-- User Profile -->
    <UserProfile 
      name="Luiz Picolo" 
      email="luiz.picolo@ifms.edu.br"
    />

    <!-- Navigation -->
    <nav class="p-4">
      <div class="mb-6">
        <h3 class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">MINHAS INFORMAÇÕES</h3>
        <ul class="space-y-1">
          <li>
            <router-link
              to="/administrador/usuarios/trocar-senha"
              class="block px-2 py-1 text-sm hover:bg-gray-100 rounded"
              :class="{ 'bg-green-50 text-green-700': activePage === 'trocar-senha', 'text-gray-700': activePage !== 'trocar-senha' }"
            >
              Trocar senha
            </router-link>
          </li>
        </ul>
      </div>

      <div class="mb-6">
        <h3 class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">ADMINISTRADOR</h3>
        <ul class="space-y-1">
          <li>
            <router-link
              to="/administrador/usuarios/listar"
              class="block px-2 py-1 text-sm hover:bg-gray-100 rounded"
              :class="{ 'bg-green-50 text-green-700': activePage === 'usuarios', 'text-gray-700': activePage !== 'usuarios' }">
              Usuários
            </router-link>
          </li>
          <li>
            <router-link
              to="/administrador/estudantes/listar"
              class="block px-2 py-1 text-sm hover:bg-gray-100 rounded"
              :class="{ 'bg-green-50 text-green-700': activePage === 'estudantes', 'text-gray-700': activePage !== 'estudantes' }"
            >
              Estudantes
            </router-link>
          </li>
          <li>
            <router-link
              to="/administrador/cursos/listar"
              class="block px-2 py-1 text-sm hover:bg-gray-100 rounded"
              :class="{ 'bg-green-50 text-green-700': activePage === 'cursos', 'text-gray-700': activePage !== 'cursos' }"
            >
              Cursos
            </router-link>
          </li>
          <li>
            <router-link
              to="/administrador/turmas/listar"
              class="block px-2 py-1 text-sm hover:bg-gray-100 rounded"
              :class="{ 'bg-green-50 text-green-700': activePage === 'turmas', 'text-gray-700': activePage !== 'turmas' }"
            >
              Turmas
            </router-link>
          </li>
        </ul>
      </div>

      <div>
        <h3 class="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2">OCORRÊNCIAS</h3>
        <ul class="space-y-1">
          <li>
            <router-link
              to="/ocorrencias/ocorrencias/listar"
              class="block px-2 py-1 text-sm hover:bg-gray-100 rounded"
              :class="{ 'bg-green-50 text-green-700': activePage === 'ocorrencias', 'text-gray-700': activePage !== 'ocorrencias' }"
            >
              Ocorrências
            </router-link>
          </li>
          <li>
            <router-link
              to="/ocorrencias/relatorio"
              class="block px-2 py-1 text-sm hover:bg-gray-100 rounded"
              :class="{ 'bg-green-50 text-green-700': activePage === 'relatorio', 'text-gray-700': activePage !== 'relatorio' }"
            >
              Relatório ocorrências
            </router-link>
          </li>
        </ul>
      </div>
    </nav>
  </aside>
</template>