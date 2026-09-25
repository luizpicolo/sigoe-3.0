<script setup>
import { onMounted,ref } from 'vue'
import { useRoute } from 'vue-router'
import MobileLayout from '@/layouts/MobileLayout.vue'
import { find } from '@/services/students'
import { can } from '@/services/permissions'
import { error } from '@/utils/sweetPopup2'
const route=useRoute(),student=ref(null),loading=ref(false),errorMessage=ref('')
onMounted(async()=>{loading.value=true;try{student.value=(await find(route.params.id))?.student}catch(e){await error(e.response?.data?.errors?.join(', ') || 'Não foi possível carregar o estudante.')}finally{loading.value=false}})
</script>
<template><MobileLayout mobile-title="Detalhes do estudante"><div v-if="loading" class="py-10 text-center text-sm text-gray-500">Carregando...</div><div v-else-if="errorMessage" class="rounded-xl bg-red-50 p-4 text-sm text-red-700">{{errorMessage}}</div><div v-else-if="student" class="space-y-4">
<div class="rounded-xl bg-white p-4 shadow-sm flex gap-4"><img :src="student.photo||'/placeholder.svg?height=120&width=120'" class="h-24 w-24 rounded-xl object-cover"><div><h2 class="text-lg font-semibold">{{student.name}}</h2><p class="text-sm text-gray-500">#{{student.id}}</p><p class="text-sm">{{student.course?.name||'-'}}</p><p class="text-sm text-gray-500">{{student.school_group?.identifier||student.school_group?.name||'-'}}</p></div></div>
<div class="rounded-xl bg-white p-4 shadow-sm"><dl class="space-y-3 text-sm"><div><dt class="text-gray-500">CPF</dt><dd>{{student.cpf||'-'}}</dd></div><div><dt class="text-gray-500">Nascimento</dt><dd>{{student.birth_date||'-'}}</dd></div><div><dt class="text-gray-500">Responsável</dt><dd>{{student.responsible||student.responsible_contact||'-'}}</dd></div><div><dt class="text-gray-500">Contato</dt><dd>{{student.contact||'-'}}</dd></div><div><dt class="text-gray-500">Campus</dt><dd>{{student.course?.polo?.name||'-'}}</dd></div></dl></div>
<div class="grid grid-cols-2 gap-2"><RouterLink v-if="can('students','update')" :to="`/mobile/students/${student.id}/edit`" class="rounded-lg bg-blue-600 px-3 py-3 text-center text-white">Editar</RouterLink><RouterLink to="/mobile/students" class="rounded-lg bg-gray-100 px-3 py-3 text-center">Voltar</RouterLink></div>
</div></MobileLayout></template>