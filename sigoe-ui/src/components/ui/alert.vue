<script setup>
defineProps({
  type: {
    type: String,
    default: 'info',
    validator: (value) => ['success', 'error', 'warning', 'info'].includes(value)
  },
  message: {
    type: String,
    required: true
  },
  dismissible: {
    type: Boolean,
    default: false
  },
  icon: {
    type: String,
    default: null
  }
})

const emit = defineEmits(['dismiss'])

const handleDismiss = () => {
  emit('dismiss')
}

// Computed classes and icons based on type
const alertClasses = (type) => {
  const classes = {
    success: 'bg-green-50 border-green-200 text-green-700',
    error: 'bg-red-50 border-red-200 text-red-700',
    warning: 'bg-yellow-50 border-yellow-200 text-yellow-700',
    info: 'bg-blue-50 border-blue-200 text-blue-700'
  }
  return `border px-4 py-3 rounded-md ${classes[type]}`
}

const defaultIcon = (type) => {
  const icons = {
    success: 'fa-circle-check',
    error: 'fa-circle-exclamation',
    warning: 'fa-triangle-exclamation',
    info: 'fa-circle-info'
  }
  return icons[type]
}
</script>

<template>
  <div :class="alertClasses(type)">
    <div class="flex items-start justify-between">
      <div class="flex items-start">
        <i :class="`fa-solid ${icon || defaultIcon(type)} mr-3 mt-0.5`"></i>
        <div class="flex-1">
          <span>{{ message }}</span>
          <slot></slot>
        </div>
      </div>
      
      <button 
        v-if="dismissible"
        @click="handleDismiss"
        class="ml-4 text-current hover:opacity-75 focus:outline-none"
      >
        <i class="fa-solid fa-times"></i>
      </button>
    </div>
  </div>
</template>
