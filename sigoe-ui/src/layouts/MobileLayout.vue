<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { logout } from '@/services/authentication'
import { can } from '@/services/permissions'

const route = useRoute()
const router = useRouter()
const title = computed(() => route.meta.mobileTitle || 'SIGOE')

const go = path => router.push(path)
const signOut = async () => { await logout(); await router.push('/') }
</script>

<template>
  <div class="min-h-screen bg-gray-50 pb-20">
    <header class="sticky top-0 z-20 bg-green-700 text-white shadow">
      <div class="flex items-center justify-between px-4 py-3">
        <div>
          <p class="text-xs opacity-80">SIGOE</p>
          <h1 class="font-semibold">{{ title }}</h1>
        </div>
        <button class="rounded-lg px-3 py-2 text-sm hover:bg-green-800" @click="signOut">Sair</button>
      </div>
    </header>

    <main class="mx-auto w-full max-w-xl p-4">
      <slot />
    </main>

    <nav class="fixed bottom-0 left-0 right-0 z-20 border-t bg-white shadow-lg">
      <div class="mx-auto grid max-w-xl grid-cols-3">
        <button class="flex flex-col items-center gap-1 px-2 py-3 text-xs" @click="go('/mobile/dashboard')">
          <i class="fa-solid fa-house text-base"></i><span>Início</span>
        </button>
        <button v-if="can('occurrences','read')" class="flex flex-col items-center gap-1 px-2 py-3 text-xs" @click="go('/mobile/incidents')">
          <i class="fa-solid fa-clipboard-list text-base"></i><span>Ocorrências</span>
        </button>
        <button v-if="can('occurrences','create')" class="flex flex-col items-center gap-1 px-2 py-3 text-xs" @click="go('/mobile/incidents/new')">
          <i class="fa-solid fa-plus text-base"></i><span>Nova</span>
        </button>
      </div>
    </nav>
  </div>
</template>