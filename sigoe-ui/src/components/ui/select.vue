<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
  id: String,
  name: String,
  label: String,
  placeholder: { type: String, default: 'Selecione uma opção' },
  options: { type: Array, default: () => [] },
  modelValue: { type: [String, Number], default: '' },
  disabled: Boolean
})

const emit = defineEmits(['update:modelValue'])
const isOpen = ref(false)
const search = ref('')
const selectedOption = computed(() => props.options.find(option => String(option.value) === String(props.modelValue)))
const filteredOptions = computed(() => {
  const term = search.value.trim().toLowerCase()
  if (!term) return props.options
  return props.options.filter(option => String(option.label).toLowerCase().includes(term))
})

const selectOption = option => {
  emit('update:modelValue', option.value)
  isOpen.value = false
  search.value = ''
}

const toggle = () => {
  if (props.disabled) return
  isOpen.value = !isOpen.value
  if (!isOpen.value) search.value = ''
}

const close = () => {
  isOpen.value = false
  search.value = ''
}
</script>

<template>
  <div class="relative">
    <label v-if="label" :for="id" class="mb-2 block text-sm font-medium text-gray-700">{{ label }}</label>
    <button :id="id" type="button" :disabled="disabled" class="flex w-full items-center justify-between rounded-md border-2 border-gray-300 bg-white px-3 py-2 text-left text-sm focus:border-green-500 focus:outline-none focus:ring-2 focus:ring-green-200 disabled:cursor-not-allowed disabled:bg-gray-100" @click="toggle">
      <span :class="selectedOption ? 'text-gray-900' : 'text-gray-500'">{{ selectedOption?.label || placeholder }}</span>
      <span class="ml-2 text-gray-500">▾</span>
    </button>
    <div v-if="isOpen" class="absolute z-30 mt-1 w-full rounded-md border border-gray-200 bg-white p-2 shadow-lg">
      <input v-model="search" type="search" placeholder="Buscar..." class="mb-2 block w-full rounded border border-gray-300 px-3 py-2 text-sm focus:border-green-500 focus:outline-none" @keydown.esc="close" />
      <div class="max-h-56 overflow-y-auto">
        <button v-for="option in filteredOptions" :key="option.value" type="button" class="block w-full rounded px-3 py-2 text-left text-sm hover:bg-green-50" :class="String(option.value) === String(modelValue) ? 'bg-green-100 font-semibold' : ''" @click="selectOption(option)">{{ option.label }}</button>
        <p v-if="!filteredOptions.length" class="px-3 py-2 text-sm text-gray-500">Nenhum resultado encontrado.</p>
      </div>
    </div>
  </div>
</template>
