<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { list as listStudents } from '@/services/students'

const props = defineProps({
  modelValue: { type: Array, default: () => [] },
  disabled: { type: Boolean, default: false }
})

const emit = defineEmits(['update:modelValue'])
const students = ref([])
const search = ref('')
const loading = ref(false)
const opened = ref(false)
let searchTimer

const selectedStudents = computed(() => props.modelValue || [])
const selectedIds = computed(() => selectedStudents.value.map(student => student.id))
const visibleStudents = computed(() => students.value.filter(student => !selectedIds.value.includes(student.id)))

const searchStudents = async () => {
  loading.value = true
  try {
    const response = await listStudents(1, 'name', search.value.trim() || null, 30)
    students.value = response?.students || []
  } finally {
    loading.value = false
  }
}

const toggleStudent = student => {
  const exists = selectedIds.value.includes(student.id)
  const nextStudents = exists
    ? selectedStudents.value.filter(item => item.id !== student.id)
    : [...selectedStudents.value, student]
  emit('update:modelValue', nextStudents)
  if (!exists) search.value = ''
}

const removeStudent = studentId => {
  emit('update:modelValue', selectedStudents.value.filter(student => student.id !== studentId))
}

watch(search, () => {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(async () => {
    if (opened.value) await searchStudents()
  }, 350)
})

watch(opened, value => {
  if (value) searchStudents()
})

onMounted(searchStudents)
</script>

<template>
  <div class="relative">
    <label class="block text-sm font-medium mb-1">Pesquisar estudante</label>
    <button type="button" class="block w-full px-3 py-2 rounded-md border-2 border-gray-300 bg-white text-left" :disabled="disabled" @click="opened = !opened">
      {{ selectedStudents.length ? `${selectedStudents.length} estudante(s) selecionado(s)` : 'Nome, R.A. ou matrícula' }}
    </button>
    <div v-if="opened" class="absolute z-20 w-full mt-1 rounded-md border-2 border-gray-300 bg-white p-2 shadow-lg">
      <input v-model="search" type="search" placeholder="Nome, R.A. ou matrícula" class="block w-full px-3 py-2 rounded-md border border-gray-300 bg-white">
      <div class="max-h-56 overflow-y-auto mt-2">
        <div v-if="loading" class="p-3 text-sm">Buscando...</div>
        <button v-for="student in visibleStudents" :key="student.id" type="button" class="block w-full text-left p-2 rounded hover:bg-gray-100" @click="toggleStudent(student)">
          {{ student.name }}{{ student.ra ? ` - ${student.ra}` : '' }}
        </button>
        <div v-if="!loading && !visibleStudents.length" class="p-3 text-sm text-gray-500">Nenhum estudante encontrado.</div>
      </div>
    </div>
    <div v-if="selectedStudents.length" class="flex flex-wrap gap-2 mt-3">
      <span v-for="student in selectedStudents" :key="student.id" class="inline-flex items-center gap-2 rounded-full bg-gray-100 px-3 py-1 text-sm">
        {{ student.name }}
        <button type="button" class="font-bold" @click="removeStudent(student.id)">×</button>
      </span>
    </div>
  </div>
</template>
