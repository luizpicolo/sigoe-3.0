<script setup>
  import { ref } from "vue";

  defineProps({
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
  });

  const imageSrc = ref("/placeholder.svg?height=48&width=48");
</script>

<template>
  <div class="p-4 border-b border-gray-200 flex items-center">
    <div class="w-12 h-12 rounded-md bg-gray-200 mr-3 overflow-hidden">
      <img :src="imageSrc" :alt="name" class="object-cover" />
    </div>
    <div>
      <h2 class="font-medium text-gray-900">{{ name }}</h2>
      <p class="text-sm text-gray-500">{{ email }}</p>
    </div>
  </div>
</template>