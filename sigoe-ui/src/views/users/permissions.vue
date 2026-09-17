<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import { find as findUser } from '@/services/users'
import { getUserPermissions, saveUserPermissions } from '@/services/permissions'

const route = useRoute()
const userId = String(route.params.id || '')

const user = ref(null)
const entities = ref([])
const permissions = ref([])
const loading = ref(false)
const saving = ref(false)
const error = ref('')
const success = ref('')
const selectedEntity = ref('')

const breadcrumbItems = [
  { label: 'Home', href: '/' },
  { label: 'Administrador', href: '/administrador' },
  { label: 'Usuários', href: '/administrador/usuarios' },
  { label: 'Visualizar', href: `/administrador/usuarios/visualizar/${userId}` },
  { label: 'Permissões', href: '#' },
]

const actions = [
  { key: 'can_create', label: 'Criar' },
  { key: 'can_read', label: 'Visualizar / Listar' },
  { key: 'can_read_restricted', label: 'Leitura restrita' },
  { key: 'can_update', label: 'Atualizar' },
  { key: 'can_destroy', label: 'Deletar' },
  { key: 'can_extras', label: 'Opções extras' },
  { key: 'can_export_to_academic_system', label: 'Exportar' },
]

const selectedUserName = computed(() => user.value?.name || user.value?.username || 'usuário')
const availableEntities = computed(() => entities.value.filter(entity => !permissions.value.some(permission => permission.entity === entity.id)))

const normalizePermissions = (rawPermissions) => Object.entries(rawPermissions || {}).map(([entity, values]) => ({
  entity,
  ...values
}))

const load = async () => {
  if (!userId) {
    error.value = 'Usuário não informado.'
    return
  }

  loading.value = true
  error.value = ''
  success.value = ''

  try {
    const [userResponse, permissionResponse] = await Promise.all([
      findUser(userId),
      getUserPermissions(userId)
    ])

    user.value = userResponse?.user || permissionResponse?.user || null
    entities.value = permissionResponse?.entities || []
    permissions.value = normalizePermissions(permissionResponse?.permissions)
  } catch (requestError) {
    error.value = requestError.response?.data?.error || 'Não foi possível carregar as permissões deste usuário.'
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

  selectedEntity.value = ''
}

const removeEntity = (index) => {
  permissions.value.splice(index, 1)
}

const save = async () => {
  saving.value = true
  error.value = ''
  success.value = ''

  try {
    const response = await saveUserPermissions(userId, permissions.value)
    permissions.value = normalizePermissions(response?.permissions)
    success.value = 'Permissões salvas com sucesso.'
  } catch (requestError) {
    error.value = requestError.response?.data?.error || 'Não foi possível salvar as permissões.'
  } finally {
    saving.value = false
  }
}

const entityName = (id) => entities.value.find(entity => entity.id === id)?.name || id

onMounted(load)
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
        <div class="flex flex-wrap justify-between items-center gap-3 mb-4">
          <div>
            <h1 class="text-2xl font-bold">Gerenciar Permissões</h1>
            <p class="text-sm text-gray-500 mt-1">Defina quais telas <strong>{{ selectedUserName }}</strong> pode acessar e quais operações pode realizar.</p>
          </div>
          <Button to="/administrador/usuarios/listar" customClass="bg-white border-gray-200 !text-gray-900 hover:bg-gray-100 !focus:ring-gray-300">
            <i class="fa-solid fa-arrow-left"></i>
            Voltar
          </Button>
        </div>

        <Card :title="`Permissões de ${selectedUserName}`">
          <div v-if="error" class="mb-4 p-3 rounded bg-red-50 text-red-700">{{ error }}</div>
          <div v-if="success" class="mb-4 p-3 rounded bg-green-50 text-green-700">{{ success }}</div>

          <div v-if="loading" class="py-10 text-center text-gray-500">Carregando permissões de {{ selectedUserName }}...</div>

          <template v-else>
            <div class="mb-6 p-4 rounded-md border border-gray-200 bg-gray-50">
              <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-3">
                <div>
                  <h2 class="font-semibold text-gray-900">Telas disponíveis</h2>
                  <p class="text-sm text-gray-500">Adicione uma tela para configurar exatamente o que o usuário poderá fazer nela.</p>
                </div>
                <div class="flex gap-2 w-full md:w-auto">
                  <select v-model="selectedEntity" class="block flex-1 md:w-72 px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm">
                    <option value="">Selecione uma tela</option>
                    <option v-for="entity in availableEntities" :key="entity.id" :value="entity.id">
                      {{ entity.name }}
                    </option>
                  </select>
                  <Button :disabled="!selectedEntity" @click="addEntity(selectedEntity)" customClass="bg-green-600 hover:bg-green-700 whitespace-nowrap">
                    <i class="fa-solid fa-plus"></i>
                    Adicionar tela
                  </Button>
                </div>
              </div>
            </div>

            <div v-if="permissions.length === 0" class="py-10 text-center border border-dashed border-gray-300 rounded-md text-gray-500">
              Nenhuma tela foi liberada para este usuário.
            </div>

            <div v-for="(permission, index) in permissions" :key="permission.entity" class="mb-5 border border-gray-200 rounded-lg overflow-hidden">
              <div class="px-4 py-3 bg-gray-100 flex flex-wrap items-center justify-between gap-3">
                <div>
                  <h2 class="font-semibold text-gray-900">{{ entityName(permission.entity) }}</h2>
                  <p class="text-xs text-gray-500">Permissões disponíveis para esta tela</p>
                </div>
                <button type="button" @click="removeEntity(index)" class="text-sm text-red-600 hover:text-red-800">
                  <i class="fa-solid fa-trash-alt mr-1"></i>
                  Remover tela
                </button>
              </div>

              <div class="p-4 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
                <label v-for="action in actions" :key="action.key" class="flex items-center gap-3 p-3 border border-gray-200 rounded-md cursor-pointer hover:bg-gray-50">
                  <input v-model="permission[action.key]" type="checkbox" class="w-5 h-5" />
                  <span class="text-sm text-gray-700">{{ action.label }}</span>
                </label>
              </div>
            </div>

            <div class="mt-6 p-4 rounded-md border border-gray-200 text-sm text-gray-600">
              <p><strong>Visualizar / Listar</strong> corresponde à permissão <code>can_read</code> usada pelo Rails para leitura da entidade.</p>
              <p class="mt-1">Assim, por exemplo, você pode adicionar <strong>Estudantes</strong> e marcar somente duas operações, como <strong>Visualizar / Listar</strong> e <strong>Atualizar</strong>. As demais permanecem desmarcadas.</p>
            </div>

            <div class="flex justify-end mt-5">
              <Button @click="save" :disabled="saving" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500">
                <i class="fa-solid fa-save mr-1"></i>
                {{ saving ? 'Salvando...' : 'Salvar Permissões' }}
              </Button>
            </div>
          </template>
        </Card>
      </main>
    </div>
  </div>
</template>
