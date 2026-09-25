<script setup>
import { onMounted,ref } from 'vue'
import { useRoute,useRouter } from 'vue-router'
import MobileLayout from '@/layouts/MobileLayout.vue'
import { find,remove } from '@/services/users'
import { can } from '@/services/permissions'
const route=useRoute(),router=useRouter(),user=ref(null),loading=ref(false),errorMessage=ref('')
const load=async()=>{loading.value=true;try{user.value=(await find(route.params.id))?.user}catch(e){errorMessage.value='Não foi possível carregar o usuário.'}finally{loading.value=false}}
const del=async()=>{if(!window.confirm('Deseja realmente excluir este usuário?'))return;try{await remove(route.params.id);await router.push('/mobile/users')}catch(e){errorMessage.value='Não foi possível excluir o usuário.'}}
onMounted(load)
</script>
<template><MobileLayout mobile-title="Detalhes do usuário"><div v-if="loading" class="py-10 text-center">Carregando...</div><div v-else-if="errorMessage" class="rounded-xl bg-red-50 p-4 text-sm text-red-700">{{errorMessage}}</div><div v-else-if="user" class="space-y-4">
<div class="rounded-xl bg-white p-4 shadow-sm"><h2 class="text-lg font-semibold">{{user.name}}</h2><p class="text-sm text-gray-500">{{user.username}}</p><p class="text-sm">{{user.email}}</p><div class="mt-3 flex gap-2 text-xs"><span class="rounded-full bg-gray-100 px-2 py-1">{{user.admin?'Administrador':'Usuário'}}</span><span class="rounded-full px-2 py-1" :class="user.status?'bg-green-100 text-green-700':'bg-red-100 text-red-700'">{{user.status?'Ativo':'Inativo'}}</span></div></div>
<div class="rounded-xl bg-white p-4 shadow-sm text-sm space-y-2"><p><b>SIAPE:</b> {{user.siape||'-'}}</p><p><b>Campus:</b> {{user.polo?.name||'-'}}</p></div>
<div class="space-y-2"><RouterLink v-if="can('users','update')" :to="`/mobile/users/${user.id}/permissions`" class="block rounded-lg bg-purple-600 px-3 py-3 text-center text-white">Gerenciar Permissões</RouterLink><RouterLink v-if="can('users','update')" :to="`/mobile/users/${user.id}/edit`" class="block rounded-lg bg-blue-600 px-3 py-3 text-center text-white">Editar</RouterLink><button v-if="can('users','destroy')" @click="del" class="w-full rounded-lg bg-red-50 px-3 py-3 text-red-700">Excluir</button><RouterLink to="/mobile/users" class="block rounded-lg bg-gray-100 px-3 py-3 text-center">Voltar</RouterLink></div>
</div></MobileLayout></template>