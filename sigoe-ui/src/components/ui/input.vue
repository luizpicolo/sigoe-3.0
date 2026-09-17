<script setup>
defineProps({
  id: String,
  name: {
    type: String,
    default: 'text'
  },
  label: {
    type: String
  },
  type: {
    type: String,
    default: 'text'
  },
  placeholder: String,
  required: {
    type: Boolean,
    default: false
  },
  modelValue: String
})

defineEmits(['update:modelValue'])
</script>

<template>
  <div>
    <template v-if="label">
      <label :for="id" class="mb-2 block text-sm font-medium text-gray-700">{{ label }}</label>
    </template>
    <input
      :id="id"
      :name="name"
      :type="type"
      :required="required"
      :placeholder="placeholder"
      :value="modelValue"
      class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm"
      @input="$emit('update:modelValue', $event.target.value)"
    />
  </div>
</template>
