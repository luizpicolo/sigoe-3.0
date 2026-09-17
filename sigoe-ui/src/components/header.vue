<script setup>
import { useRouter } from 'vue-router'
import { logout } from '@/services/authentication'

const router = useRouter()

const handleLogout = async () => {
  if (await logout()) {
    router.push('/')
  }
}
</script>

<template>
  <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center">
    <div class="flex items-center">
      <RouterLink to="/home">
        <img src="/logo_ifms.png" width="160">
      </RouterLink>
    </div>
    <div class="text-sm">
      SIGOE - Controle de ocorrências escolares - <span class="text-green-600">
        <button @click.prevent="handleLogout">
          Sair
        </button>
      </span>
    </div>
  </header>
</template>

<style scoped>
a:hover {
  background-color: transparent;
}
</style>