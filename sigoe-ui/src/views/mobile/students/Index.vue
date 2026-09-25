<script setup>
import { onMounted, ref } from 'vue'
import MobileLayout from '@/layouts/MobileLayout.vue'
import { list } from '@/services/students'
import { can, permissionState } from '@/services/permissions'
import { error } from '@/utils/sweetPopup2'

const page=ref(1), amount=ref(10), order=ref('id'), search=ref('')
const students=ref([]), total=ref(0), loading=ref(false), errorMessage=ref('')
const showCampus=()=>permissionState.user?.super_admin===true
const load=async()=>{loading.value=true;errorMessage.value='';try{const r=await list(page.value,order.value,search.value,amount.value);students.value=r?.students||[];total.value=r?.total||0}catch(e){await error(e.response?.data?.errors?.join(', ') || 'Não foi possível carregar os estudantes.'); errorMessage.value='' }finally{loading.value=false}}
const searchStudents=()=>{page.value=1;load()}
onMounted(load)
</script>
<template>
<MobileLayout mobile-title="Estudantes"><div class="space-y-4">
<div class="flex items-center justify-between"><div><h2 class="text-lg font-semibold">Estudantes</h2><p class="text-xs text-gray-500">{{ total }} registro(s)</p></div><RouterLink v-if="can('students','create')" to="/mobile/students/new" class="rounded-lg bg-green-600 px-3 py-2 text-sm text-white"><i class="fa-solid fa-user-plus mr-1"></i>Novo</RouterLink></div>
<div class="rounded-xl bg-white p-3 shadow-sm"><div class="flex gap-2"><input v-model="search" @keyup.enter="searchStudents" type="search" placeholder="Buscar estudante..." class="min-w-0 flex-1 rounded-lg border border-gray-300 px-3 py-2 text-sm"><button @click="searchStudents" class="rounded-lg bg-gray-100 px-3 py-2"><i class="fa-solid fa-magnifying-glass"></i></button></div><select v-model="order" @change="page=1;load()" class="mt-2 w-full rounded-lg border border-gray-300 px-3 py-2 text-sm"><option value="id">Ordenar por ID</option><option value="name">Ordenar por nome</option></select></div>
<div v-if="loading" class="py-10 text-center text-sm text-gray-500">Carregando estudantes...</div><div v-else-if="errorMessage" class="rounded-xl bg-red-50 p-4 text-sm text-red-700">{{ errorMessage }}</div><div v-else class="space-y-3">
<article v-for="s in students" :key="s.id" class="rounded-xl bg-white p-4 shadow-sm"><div class="flex gap-3"><img :src="s.photo || '/placeholder.svg?height=80&width=80'" class="h-16 w-16 shrink-0 rounded-lg object-cover"><div class="min-w-0 flex-1"><p class="text-xs text-gray-500">#{{ s.id }}</p><h3 class="font-semibold break-words">{{ s.name }}</h3><p class="text-sm text-gray-500">{{ s.school_group?.identifier || s.school_group?.name || 'Sem turma' }}</p><p v-if="showCampus() && s.course?.polo?.name" class="text-xs text-gray-500">Campus: {{ s.course.polo.name }}</p><p class="text-xs text-gray-500">{{ s.course?.name || 'Curso não informado' }}</p></div></div><RouterLink v-if="can('students','read')" :to="`/mobile/students/${s.id}`" class="mt-3 block rounded-lg bg-gray-100 px-3 py-2 text-center text-sm">Visualizar</RouterLink></article>
<div v-if="!students.length" class="rounded-xl bg-white p-6 text-center text-sm text-gray-500">Nenhum estudante encontrado.</div></div>
<div v-if="!loading && total>amount" class="flex items-center justify-between rounded-xl bg-white p-3 text-sm shadow-sm"><button :disabled="page<=1" @click="page--;load()" class="rounded-lg bg-gray-100 px-3 py-2 disabled:opacity-40">Anterior</button><span>Página {{ page }} de {{ Math.ceil(total/amount) }}</span><button :disabled="page>=Math.ceil(total/amount)" @click="page++;load()" class="rounded-lg bg-gray-100 px-3 py-2 disabled:opacity-40">Próxima</button></div>
</div></MobileLayout></template>