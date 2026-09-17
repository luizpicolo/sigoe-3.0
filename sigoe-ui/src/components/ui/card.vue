<script setup>
  defineProps({
    title: String,
    description: String,
    customClass: String,
    icon: String
  })
</script>

<template>
  <div :class="`bg-white p-4 border border-gray-200 rounded-md ${ customClass }`">
    <div v-if="title" class="border-b border-gray-200 pb-2 mb-4">
      <h2 class="text-sm font-black text-black">
        <i v-if="icon" :class="`fa-solid fa-${icon} mr-2`"></i>
        {{ title }}
      </h2>
    </div>
    <p v-if="description" class="text-sm text-gray-600 mb-4">{{ description }}</p>
    <slot></slot>
  </div>
</template>
