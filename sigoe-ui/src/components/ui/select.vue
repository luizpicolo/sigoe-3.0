<script setup>
  defineProps({
    name: String,
    label: String,
    options: []
  });
</script>

<template>
  <label :for="id" class="mb-2 block text-sm font-medium text-gray-700">{{ label }}</label>
  <select
    :v-model="selectedCampus"
    :name="name"
    class="block w-full px-3 py-2 border-2 border-gray-300 bg-white rounded-md focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm"
  >
    <option v-for="option in options" :key="option.value" :value="option.value">
      {{ option.label }}
    </option>
  </select>
</template>