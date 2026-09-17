<script setup>
import { computed } from 'vue'

const props = defineProps({
  variant: {
    type: String,
    default: 'primary',
    validator: (value) => ['primary', 'secondary', 'success', 'danger', 'warning', 'info'].includes(value)
  },
  size: {
    type: String,
    default: 'md',
    validator: (value) => ['sm', 'md', 'lg'].includes(value)
  },
  customClass: {
    type: String,
    default: ''
  },
  type: {
    type: String,
    default: 'button'
  },
  to: {
    type: String,
    default: null
  },
  disabled: {
    type: Boolean,
    default: false
  },
  loading: {
    type: Boolean,
    default: false
  },
  block: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['click'])

const buttonClasses = computed(() => {
  const baseClasses = 'inline-flex items-center justify-center border rounded-md shadow-sm font-medium focus:outline-none focus:ring-2 focus:ring-offset-2 transition-colors duration-200'
  
  const variantClasses = {
    primary: 'border-transparent text-white bg-green-600 hover:bg-green-700 focus:ring-green-500',
    secondary: 'border-gray-300 text-gray-700 bg-white hover:bg-gray-50 focus:ring-gray-500',
    success: 'border-transparent text-white bg-green-600 hover:bg-green-700 focus:ring-green-500',
    danger: 'border-transparent text-white bg-red-600 hover:bg-red-700 focus:ring-red-500',
    warning: 'border-transparent text-white bg-yellow-600 hover:bg-yellow-700 focus:ring-yellow-500',
    info: 'border-transparent text-white bg-blue-600 hover:bg-blue-700 focus:ring-blue-500'
  }
  
  const sizeClasses = {
    sm: 'px-3 py-1.5 text-sm',
    md: 'px-4 py-2 text-sm',
    lg: 'px-6 py-3 text-base'
  }
  
  const blockClass = props.block ? 'w-full' : ''
  const disabledClass = (props.disabled || props.loading) ? 'opacity-50 cursor-not-allowed' : ''
  
  return `${baseClasses} ${variantClasses[props.variant]} ${sizeClasses[props.size]} ${blockClass} ${disabledClass} ${props.customClass}`
})

const handleClick = (event) => {
  if (!props.disabled && !props.loading) {
    emit('click', event)
  }
}
</script>

<template>
  <RouterLink v-if="to && !disabled && !loading" :to="to" class="inline-block`">
    <button
      :type="type"
      :class="buttonClasses"
      @click="handleClick"
    >
      <i v-if="loading" class="fa-solid fa-spinner fa-spin mr-2"></i>
      <slot></slot>
    </button>
  </RouterLink>
  
  <button
    v-else
    :type="type"
    :disabled="disabled || loading"
    :class="buttonClasses"
    @click="handleClick"
  >
    <i v-if="loading" class="fa-solid fa-spinner fa-spin mr-2"></i>
    <slot></slot>
  </button>
</template>
