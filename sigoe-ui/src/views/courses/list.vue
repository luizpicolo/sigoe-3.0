<script setup>
import { ref, onMounted } from 'vue'
import Header from '@/components/header.vue'; import Sidebar from '@/components/sidebar.vue'; import Breadcrumb from '@/components/breadcrumb.vue'; import Button from '@/components/ui/button.vue'
import { list, remove } from '@/services/courses'
const courses=ref([]), error=ref('')
const load=async()=>{try{courses.value=(await list()).courses||[]}catch(e){error.value='Não foi possível carregar os cursos'}}
const destroy=async id=>{if(confirm('Excluir este curso?')){await remove(id);await load()}}
onMounted(load)
</script>
<template><div class="min-h-screen"><Header/><div class="flex flex-col md:flex-row"><Sidebar activePage="cursos"/><main class="flex-1 p-6"><Breadcrumb :items="[{label:'Home',href:'/home'},{label:'Administrador'},{label:'Cursos'}]"/><div class="flex justify-between items-center mb-6"><h1 class="text-2xl font-bold">Cursos</h1><Button to="/administrador/cursos/novo" customClass="bg-green-600">Novo curso</Button></div><p class="text-red-600">{{error}}</p><div class="bg-white rounded-md shadow overflow-auto"><table class="min-w-full"><thead class="bg-gray-100"><tr><th class="p-3 text-left">ID</th><th class="p-3 text-left">Nome</th><th class="p-3 text-left">Sigla</th><th class="p-3">Ações</th></tr></thead><tbody><tr v-for="c in courses" :key="c.id" class="border-t"><td class="p-3">{{c.id}}</td><td class="p-3">{{c.name}}</td><td class="p-3">{{c.initial}}</td><td class="p-3 flex gap-2"><Button :to="`/administrador/cursos/editar/${c.id}`" customClass="bg-blue-600">Editar</Button><Button @click="destroy(c.id)" customClass="bg-red-600">Excluir</Button></td></tr></tbody></table></div></main></div></div></template>
