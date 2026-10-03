<script setup>
import { ref } from 'vue'
import { error, success, confirm } from '@/utils/sweetPopup2'
import { uploadAttachment, removeAttachment, downloadAttachment } from '@/services/incidents'
import Button from '@/components/ui/button.vue'
import Card from '@/components/ui/card.vue'
import { can } from '@/services/permissions'


const props = defineProps({
  incidentId: { type: [String, Number], required: true },
  attachments: { type: Array, default: () => [] },
})

const emit = defineEmits(['uploaded', 'deleted'])

const fileInput = ref(null)
const isUploading = ref(false)

const selectFile = () => {
  fileInput.value?.click()
}

const upload = async event => {
  const file = event.target.files?.[0]
  event.target.value = ''

  if (!file) return

  if (file.type !== 'application/pdf' && !file.name.toLowerCase().endsWith('.pdf')) {
    error('Selecione um arquivo PDF.')
    return
  }

  isUploading.value = true

  try {
    const response = await uploadAttachment(props.incidentId, file)
    emit('uploaded', response.attachment)
    await success('PDF anexado com sucesso.')
  } catch (exception) {
    error(exception.response?.data?.errors?.join(', ') || 'Não foi possível anexar o PDF.')
  } finally {
    isUploading.value = false
  }
}

const download = async attachment => {
  try {
    const blob = await downloadAttachment(props.incidentId, attachment.id)
    const url = URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = attachment.filename
    document.body.appendChild(link)
    link.click()
    link.remove()
    setTimeout(() => URL.revokeObjectURL(url), 1000)
  } catch {
    error('Não foi possível baixar o PDF.')
  }
}

const deleteAttachment = async attachment => {
  if (!(await confirm('Excluir o arquivo "' + attachment.filename + '"?'))) return

  try {
    await removeAttachment(props.incidentId, attachment.id)
    emit('deleted', attachment.id)
    await success('PDF excluído com sucesso.')
  } catch (exception) {
    error(exception.response?.data?.errors?.join(', ') || 'Não foi possível excluir o PDF.')
  }
}
</script>

<template>
  <Card customClass="col-span-4" title="Arquivos PDF">
    <div class="mb-4 flex items-start gap-2 rounded-md border border-amber-200 bg-amber-50 p-3 text-sm text-amber-800" role="alert">
      <i class="fa-solid fa-triangle-exclamation mt-0.5"></i>
      <span>Espaço destinado a ocorrências assinadas pelo estudante.</span>
    </div>
    
    <div class="space-y-3">
      <div class="flex items-center gap-3">
        <input ref="fileInput" type="file" accept="application/pdf,.pdf" class="hidden" @change="upload" />
        <Button :disabled="!can('occurrences', 'attach_pdf')" customClass="bg-blue-600 hover:bg-blue-700" @click="selectFile">
          <i class="fa-solid fa-file-arrow-up pr-2"></i>
          {{ isUploading ? 'Enviando...' : 'Adicionar PDF' }}
        </Button>
      </div>

      <div v-if="!attachments.length" class="text-sm text-gray-500">
        Nenhum PDF anexado.
      </div>

      <ul v-else class="divide-y divide-gray-200">
        <li v-for="attachment in attachments" :key="attachment.id" class="py-3 flex items-center justify-between gap-3">
          <button type="button" @click="download(attachment)" class="text-sm text-blue-600 hover:underline flex items-center gap-2">
            <i class="fa-solid fa-file-pdf"></i>
            {{ attachment.filename }}
          </button>

          <Button :disabled="!can('occurrences', 'update')" customClass="bg-red-600 hover:bg-red-700" @click="deleteAttachment(attachment)">
            <i class="fa-solid fa-trash p-1"></i>
            Excluir
          </Button>
        </li>
      </ul>
    </div>
  </Card>
</template>
