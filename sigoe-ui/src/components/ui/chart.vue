<script setup>
import { computed } from 'vue'

const props = defineProps({
  title: { type: String, required: true },
  data: { type: Object, default: () => ({}) }
})

const entries = computed(() => Object.entries(props.data || {}).filter(([, value]) => Number(value) > 0))
const maxValue = computed(() => Math.max(...entries.value.map(([, value]) => Number(value)), 1))
</script>

<template>
  <div class="bg-white border border-gray-200 rounded-md p-4 min-h-72">
    <h2 class="text-sm font-black text-black border-b border-gray-200 pb-2 mb-4">{{ title }}</h2>
    <div v-if="entries.length" class="space-y-4">
      <div v-for="[label, value] in entries" :key="label" class="space-y-1">
        <div class="flex justify-between gap-3 text-xs text-gray-600">
          <span class="truncate">{{ label }}</span>
          <span class="font-bold text-gray-900">{{ value }}</span>
        </div>
        <div class="h-3 rounded bg-gray-100 overflow-hidden">
          <div class="h-full rounded bg-blue-400" :style="{ width: `${(Number(value) / maxValue) * 100}%` }"></div>
        </div>
      </div>
    </div>
    <p v-else class="text-sm text-gray-500">Nenhum dado disponível.</p>
  </div>
</template>
