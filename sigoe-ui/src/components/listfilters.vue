<script setup>
import Button from '@/components/ui/button.vue'
import Input from '@/components/ui/input.vue'

defineProps({
  search: {
    type: String,
    default: ''
  },
  order: {
    type: String,
    default: 'id'
  },
  amount: {
    type: Number,
    default: 10
  },
  searchPlaceholder: {
    type: String,
    default: 'Buscar...'
  },
  orderOptions: {
    type: Array,
    default: () => [
      { label: 'ID', value: 'id' },
      { label: 'Data', value: 'date_incident' }
    ]
  },
  amountOptions: {
    type: Array,
    default: () => [10, 25, 50, 100]
  },
  showCreateButton: {
    type: Boolean,
    default: true
  },
  createPermission: {
    type: Boolean,
    default: true
  },
  createLabel: {
    type: String,
    default: 'Novo registro'
  },
  createRoute: {
    type: String,
    default: ''
  },
  createIcon: {
    type: String,
    default: 'fa-solid fa-plus'
  }
})

const emit = defineEmits([
  'update:search',
  'update:order',
  'update:amount',
  'search',
  'filter-change'
])

const updateSearch = value => {
  emit('update:search', value)
}

const updateOrder = event => {
  emit('update:order', event.target.value)
  emit('filter-change')
}

const updateAmount = event => {
  emit('update:amount', Number(event.target.value))
  emit('filter-change')
}
</script>

<template>
  <div class="bg-white rounded-md shadow p-4 mb-6">
    <div class="flex flex-wrap gap-2">
      <Button v-if="showCreateButton" :disabled="!createPermission" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500" :to="createRoute">
        <i :class="[createIcon, 'pr-2']"></i>
        {{ createLabel }}
      </Button>

      <div class="flex items-center gap-2 ml-auto">
        <label class="text-sm">Ordenar por</label>
        <select :value="order" @change="updateOrder" class="block w-[180px] px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm">
          <option v-for="option in orderOptions" :key="option.value" :value="option.value">
            {{ option.label }}
          </option>
        </select>
      </div>

      <div class="flex items-center gap-2">
        <label class="text-sm">Total</label>
        <select :value="amount" @change="updateAmount" class="block w-[80px] px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm">
          <option v-for="option in amountOptions" :key="option" :value="option">
            {{ option }}
          </option>
        </select>
      </div>

      <div class="flex items-center gap-2">
        <Input :model-value="search" type="text" :placeholder="searchPlaceholder" class="w-[200px]" @update:model-value="updateSearch" @keyup.enter="emit('search')" />
        <Button @click="emit('search')" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500">
          <i class="fa-solid fa-magnifying-glass pr-2"></i>
          Busca
        </Button>
      </div>
    </div>
  </div>
</template>