<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import { list as listUsers } from '@/services/users'
import { getUserPermissions, saveUserPermissions } from '@/services/permissions'

const route = useRoute()
const router = useRouter()

const users = ref([])
const selectedUserId = ref(String(route.params.id || ''))
const entities = ref([])
const permissions = ref([])
const loading = ref(false)
const saving = ref(false)
const error = ref('')
const success = ref('')

const breadcrumbItems = [
  { label: 'Home', href: '/' },
  { label: 'Administrador', href: '/administrador' },
  { label: 'Usuários', href: '/administrador/usuarios' },
  { label: 'Permissões', href: '#' },
]

const selectedUser = computed(() => users.value.find(user => String(user.id) === String(selectedUserId.value)))

const actions = [
  { key: 'can_create', label: 'Criar' },
  { key: 'can_read', label: 'Ler' },
  { key: 'can_read_restricted', label: 'Leitura Restrita' },
  { key: 'can_update', label: 'Atualizar' },
  { key: 'can_destroy', label: 'Deletar' },
  { key: 'can_extras', label: 'Opções extras' },
  { key: 'can_export_to_academic_system', label: 'Exportar' },
]

const loadUsers = async () => {
  const response = await listUsers(1, 'name')
  users.value = response?.users || []

  if (!selectedUserId.value && users.value.length) {
    selectedUserId.value = String(users.value[0].id)
  }
}

const loadPermissions = async () => {
  if (!selectedUserId.value) return

  loading.value = true
  error.value = ''
  success.value = ''
  try {
    const response = await getUserPermissions(selectedUserId.value)
    entities.value = response.entities || []
    permissions.value = Object.entries(response.permissions || {}).map(([entity, values]) => ({
      entity,
      ...values
    }))
  } catch (requestError) {
    error.value = requestError.response?.data?.error || 'Não foi possível carregar as permissões.'
  } finally {
    loading.value = false
  }
}

const addEntity = (entityId) => {
  if (!entityId || permissions.value.some(permission => permission.entity === entityId)) return
  permissions.value.push({
    entity: entityId,
    can_create: false,
    can_read: false,
    can_read_restricted: false,
    can_update: false,
    can_destroy: false,
    can_extras: false,
    can_export_to_academic_system: false
  })
}

const selectedEntity = ref('')

const removeEntity = (index) => permissions.value.splice(index, 1)

const save = async () => {
  saving.value = true
  error.value = ''
  success.value = ''
  try {
    const response = await saveUserPermissions(selectedUserId.value, permissions.value)
    permissions.value = Object.entries(response.permissions || {}).map(([entity, values]) => ({
      entity,
      ...values
    }))
    success.value = 'Permissões salvas com sucesso.'
  } catch (requestError) {
    error.value = requestError.response?.data?.error || 'Não foi possível salvar as permissões.'
  } finally {
    saving.value = false
  }
}

const changeUser = async () => {
  await router.replace(`/administrador/usuarios/permissoes/${selectedUserId.value}`)
  await loadPermissions()
}

const entityName = (id) => entities.value.find(entity => entity.id === id)?.name || id

onMounted(async () => {
  await loadUsers()
  await loadPermissions()
})
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center">
      <div class="flex items-center">
        <img src="/logo_ifms.png" width="160">
      </div>
      <div class="text-sm">SIGOE - Controle de ocorrências escolares</div>
    </header>

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'usuarios'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />
        <h1 class="text-2xl font-bold mb-1">Gerenciar Permissões</h1>

        <div class="flex justify-end">
          <Button to="/administrador/usuarios/listar" customClass="bg-white border-gray-200 !text-gray-900 hover:bg-gray-100 !focus:ring-gray-300">
            <i class="fa-solid fa-arrow-left"></i>
            Voltar
          </Button>
        </div>

        <div class="mb-6 mt-4 rounded-lg shadow-sm">
          <Card :title="`Permissões de ${selectedUser?.name || selectedUser?.username || 'usuário'}`">
            <div v-if="error" class="mb-4 p-3 rounded bg-red-50 text-red-700">{{ error }}</div>
            <div v-if="success" class="mb-4 p-3 rounded bg-green-50 text-green-700">{{ success }}</div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Usuário</label>
                <select v-model="selectedUserId" @change="changeUser" class="block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm">
                  <option v-for="user in users" :key="user.id" :value="String(user.id)">
                    {{ user.name || user.username }} — {{ user.email }}
                  </option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Adicionar entidade</label>
                <div class="flex gap-2">
                  <select v-model="selectedEntity" class="block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm">
                    <option value="">Selecione uma entidade</option>
                    <option
                      v-for="entity in entities.filter(entity => !permissions.some(permission => permission.entity === entity.id))"
                      :key="entity.id"
                      :value="entity.id"
                    >
                      {{ entity.name }}
                    </option>
                  </select>
                  <Button @click="addEntity(selectedEntity); selectedEntity = ''" customClass="bg-green-600 hover:bg-green-700 whitespace-nowrap">
                    Adicionar
                  </Button>
                </div>
              </div>
            </div>

            <div v-if="loading" class="py-8 text-center text-gray-500">Carregando permissões...</div>
            <div v-else class="overflow-x-auto">
              <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-100">
                  <tr>
                    <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Entidade</th>
                    <th v-for="action in actions" :key="action.key" class="px-4 py-3 text-center text-xs font-medium text-gray-500 uppercase">{{ action.label }}</th>
                    <th class="px-4 py-3 text-center text-xs font-medium text-gray-500 uppercase">Ações</th>
                  </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                  <tr v-for="(permission, index) in permissions" :key="permission.entity">
                    <td class="px-4 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ entityName(permission.entity) }}</td>
                    <td v-for="action in actions" :key="action.key" class="px-4 py-4 text-center">
                      <input v-model="permission[action.key]" type="checkbox" class="w-5 h-5" />
                    </td>
                    <td class="px-4 py-4 text-center">
                      <button type="button" @click="removeEntity(index)" class="text-red-600 hover:text-red-800" title="Remover entidade">
                        <i class="fa-solid fa-trash-alt"></i>
                      </button>
                    </td>
                  </tr>
                  <tr v-if="permissions.length === 0">
                    <td :colspan="actions.length + 2" class="px-4 py-8 text-center text-gray-500">Nenhuma permissão configurada.</td>
                  </tr>
                </tbody>
              </table>
            </div>

            <div class="bg-gray-50 p-4 rounded-md border border-gray-200 mt-6 text-sm text-gray-600">
              <p><strong>Ler:</strong> permite listar e visualizar a entidade.</p>
              <p><strong>Leitura Restrita:</strong> mantém a permissão específica de leitura restrita existente no Rails.</p>
              <p><strong>Opções extras:</strong> habilita as operações extras definidas pelo Rails para a entidade.</p>
              <p><strong>Exportar:</strong> habilita a exportação para o sistema acadêmico quando suportada.</p>
            </div>

            <div class="flex justify-end mt-4">
              <Button @click="save" :disabled="saving" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500">
                <i class="fa-solid fa-save mr-1"></i>
                {{ saving ? 'Salvando...' : 'Salvar Permissões' }}
              </Button>
            </div>
          </Card>
        </div>
      </main>
    </div>
  </div>
</template>
