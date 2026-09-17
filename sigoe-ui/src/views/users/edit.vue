<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { find, update } from '@/services/users'
import Header from '@/components/header.vue'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'

const route = useRoute(); const router = useRouter(); const loading = ref(true); const error = ref('')
const form = ref({ name: '', email: '', username: '', siape: '', polo_id: '', admin: false, status: true, password: '', password_confirmation: '' })
onMounted(async () => { try { const result = await find(route.params.id); form.value = { ...form.value, ...result.user } } catch (e) { error.value = 'Não foi possível carregar o usuário.' } finally { loading.value = false } })
const submit = async () => { error.value = ''; try { await update(route.params.id, form.value); router.push(`/administrador/usuarios/visualizar/${route.params.id}`) } catch (e) { error.value = e.response?.data?.errors?.join(', ') || 'Erro ao atualizar usuário.' } }
</script>
<template>
  <div class="min-h-screen"><Header/><div class="flex"><Sidebar :activePage="'usuarios'"/><main class="flex-1 p-6"><h1 class="text-2xl font-bold mb-6">Editar Usuário</h1><p v-if="error" class="text-red-600 mb-4">{{ error }}</p><form v-if="!loading" @submit.prevent="submit" class="max-w-2xl space-y-4 bg-white p-6 rounded shadow"><label class="block">Nome<input v-model="form.name" required class="w-full border p-2 rounded"/></label><label class="block">E-mail<input v-model="form.email" type="email" required class="w-full border p-2 rounded"/></label><label class="block">Usuário<input v-model="form.username" required class="w-full border p-2 rounded"/></label><label class="block">SIAPE<input v-model="form.siape" class="w-full border p-2 rounded"/></label><label class="block">Nova senha (opcional)<input v-model="form.password" type="password" class="w-full border p-2 rounded"/></label><label class="block">Confirmar senha<input v-model="form.password_confirmation" type="password" class="w-full border p-2 rounded"/></label><label><input type="checkbox" v-model="form.admin"/> Administrador</label><label class="block"><input type="checkbox" v-model="form.status"/> Ativo</label><div class="flex gap-2"><Button type="submit" variant="success">Salvar</Button><Button to="/administrador/usuarios/listar" variant="secondary">Cancelar</Button></div></form></main></div></div>
</template>
