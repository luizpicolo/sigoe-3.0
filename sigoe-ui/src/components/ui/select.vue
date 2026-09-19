<script setup>
defineProps({
  id: String,
  name: String,
  label: String,
  options: {
    type: Array,
    default: () => []
  },
  modelValue: {
    type: [String, Number],
    default: ''
  }
})

defineEmits(['update:modelValue'])
</script>

<template>
  <label v-if="label" :for="id" class="mb-2 block text-sm font-medium text-gray-700">{{ label }}</label>
  <select
    :id="id"
    :name="name || id"
    :value="modelValue"
    class="block w-full px-3 py-2 border-2 border-gray-300 bg-white rounded-md focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm"
    @change="$emit('update:modelValue', $event.target.value)"
  >
    <option v-for="option in options" :key="option.value" :value="option.value">
      {{ option.label }}
    </option>
  </select>
</template>
