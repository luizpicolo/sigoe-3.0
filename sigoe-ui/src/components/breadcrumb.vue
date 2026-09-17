<script setup>
defineProps({
  items: {
    type: Array,
    required: true,
    validator: (value) =>
      value.every(
        (item) =>
          typeof item.label === "string" && typeof item.href === "string"
      ),
  },
});
</script>

<template>
  <nav class="flex text-sm mb-6" aria-label="Breadcrumb">
    <ol class="inline-flex items-center space-x-1 md:space-x-2">
      <li
        v-for="(item, index) in items"
        :key="item.href"
        class="inline-flex items-center"
      >
        <span v-if="index > 0" class="mx-2 text-gray-400">&gt;</span>
        <span v-if="index === items.length - 1" class="text-gray-500">
          {{ item.label }}
        </span>
        <router-link
          v-else
          :to="item.href"
          class="text-green-600 hover:text-green-800"
        >
          {{ item.label }}
        </router-link>
      </li>
    </ol>
  </nav>
</template>