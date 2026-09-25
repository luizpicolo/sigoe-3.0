<script setup>
import { onMounted, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'

import MobileLayout from '@/layouts/MobileLayout.vue'
import {
  getUserPermissions,
  saveUserPermissions
} from '@/services/permissions'
import { can } from '@/services/permissions'
import { confirm, error, success } from '@/utils/sweetPopup2'

const route = useRoute()
const router = useRouter()
const user = ref(null)
const entities = ref([])
const permissions = ref([])
const selected = ref('')
const loading = ref(false)
const saving = ref(false)
const errorMessage = ref('')

const actions = [
  {
    key: 'can_create',
    label: 'Criar'
  },
  {
    key: 'can_read',
    label: 'Visualizar / Listar'
  },
  {
    key: 'can_update',
    label: 'Atualizar'
  },
  {
    key: 'can_destroy',
    label: 'Deletar'
  }
]

const load = async () => {
  loading.value = true

  try {
    const response = await getUserPermissions(route.params.id)

    user.value = response?.user
    entities.value = response?.entities || []
    permissions.value = Object.entries(
      response?.permissions || {}
    ).map(([entity, values]) => ({
      entity,
      ...values
    }))
  } catch (e) {
    await error(
      e.response?.data?.error ||
        'Não foi possível carregar as permissões.'
    )
  } finally {
    loading.value = false
  }
}

const add = () => {
  if (
    !selected.value ||
    permissions.value.some(
      permission => permission.entity === selected.value
    )
  ) {
    return
  }

  permissions.value.push({
    entity: selected.value,
    can_create: false,
    can_read: false,
    can_update: false,
    can_destroy: false,
    can_read_restricted: false,
    can_extras: false,
    can_sanction: false,
    can_export_to_academic_system: false
  })

  selected.value = ''
}

const save = async () => {
  saving.value = true

  try {
    const response = await saveUserPermissions(
      route.params.id,
      permissions.value
    )

    permissions.value = Object.entries(
      response?.permissions || {}
    ).map(([entity, values]) => ({
      entity,
      ...values
    }))

    await success('Permissões salvas com sucesso!')
  } catch (e) {
    await error(
      e.response?.data?.error ||
        'Não foi possível salvar as permissões.'
    )
  } finally {
    saving.value = false
  }
}

const entityName = id => {
  return entities.value.find(entity => entity.id === id)?.name || id
}

onMounted(load)
</script>

<template>
  <MobileLayout mobile-title="Permissões">
    <div class="space-y-4">
      <div
        v-if="loading"
        class="py-10 text-center"
      >
        Carregando...
      </div>

      <template v-else>
        <div class="rounded-xl bg-white p-4 shadow-sm">
          <h2 class="font-semibold">
            Permissões de {{ user?.name || user?.username }}
          </h2>

          <select
            v-model="selected"
            class="mt-3 w-full rounded-lg border px-3 py-3"
          >
            <option value="">
              Adicionar tela
            </option>

            <option
              v-for="entity in entities.filter(
                entity =>
                  !permissions.some(
                    permission => permission.entity === entity.id
                  )
              )"
              :key="entity.id"
              :value="entity.id"
            >
              {{ entity.name }}
            </option>
          </select>

          <button
            @click="add"
            class="mt-2 w-full rounded-lg bg-green-600 px-3 py-3 text-white"
          >
            Adicionar tela
          </button>
        </div>

        <div
          v-for="(permission, index) in permissions"
          :key="permission.entity"
          class="rounded-xl bg-white p-4 shadow-sm"
        >
          <div class="flex justify-between">
            <h3 class="font-semibold">
              {{ entityName(permission.entity) }}
            </h3>

            <button
              @click="permissions.splice(index, 1)"
              class="text-sm text-red-600"
            >
              Remover
            </button>
          </div>

          <div class="mt-3 grid grid-cols-2 gap-2">
            <label
              v-for="action in actions"
              :key="action.key"
              class="flex items-center gap-2 rounded-lg bg-gray-50 p-3 text-sm"
            >
              <input
                v-model="permission[action.key]"
                type="checkbox"
              />
              {{ action.label }}
            </label>

            <label
              v-if="permission.entity === 'occurrences'"
              class="flex items-center gap-2 rounded-lg bg-gray-50 p-3 text-sm"
            >
              <input
                v-model="permission.can_sanction"
                type="checkbox"
              />
              Aplicar sanção
            </label>

            <label
              v-if="permission.entity === 'occurrences'"
              class="flex items-center gap-2 rounded-lg bg-gray-50 p-3 text-sm"
            >
              <input
                v-model="permission.can_export_to_academic_system"
                type="checkbox"
              />
              Exportar
            </label>

            <label
              v-if="permission.entity === 'occurrences'"
              class="flex items-center gap-2 rounded-lg bg-gray-50 p-3 text-sm"
            >
              <input
                v-model="permission.can_read_restricted"
                type="checkbox"
              />
              Leitura restrita
            </label>
          </div>
        </div>

        <button
          @click="save"
          :disabled="saving"
          class="w-full rounded-lg bg-green-600 px-4 py-3 text-white"
        >
          {{ saving ? 'Salvando...' : 'Salvar Permissões' }}
        </button>

        <RouterLink
          :to="`/mobile/users/${route.params.id}`"
          class="block rounded-lg bg-gray-100 px-4 py-3 text-center"
        >
          Voltar
        </RouterLink>
      </template>
    </div>
  </MobileLayout>
</template>
