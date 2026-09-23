<script setup>
  import { ref } from "vue";

  const BASE_URL = import.meta.env.VITE_API_URL || "http://localhost:3000";

  defineProps({
    stateUser: {
      type: Object
    }
  });
</script>

<template>
  <div class="p-4 border-b border-gray-200 flex items-center">
    <div class="w-12 h-12 rounded-md bg-gray-200 mr-3 overflow-hidden">
      <img :src="BASE_URL + '/' + stateUser?.user?.avatar?.url" :alt="stateUser.name" class="h-12 w-12 rounded-full object-cover" />
    </div>
    <div>
      <h2 class="font-medium text-gray-900">{{ stateUser.user?.name }}</h2>
      <p class="text-sm text-gray-500">{{ stateUser.user?.email }}</p>
    </div>
  </div>
</template>