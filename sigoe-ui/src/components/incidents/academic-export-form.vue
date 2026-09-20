<script setup>
import { ref } from 'vue'

const props = defineProps({
  incident: { type: Object, required: true },
  action: { type: String, required: true }
})

const emit = defineEmits(['close'])
const atendimentoTipoId = ref('')
const descricao = ref(props.incident.description || '')
const dataAtendimento = ref(props.incident.date_incident || '')
const processoSuap = ref('')
const tipos = [
  [23, 'Assistentes de Alunos > Atendimento administrativo à comunidade externa'], [27, 'Assistentes de Alunos > Atendimento administrativo ao docente'], [21, 'Assistentes de Alunos > Atendimento administrativo ao estudante'], [24, 'Assistentes de Alunos > Atendimento administrativo aos pais e/ou responsáveis'], [8, 'Biblioteca > Acessibilidade Informacional'], [6, 'Biblioteca > Atendimento Administrativo'], [4, 'Biblioteca > Atendimento Letramento Informacional'], [7, 'Biblioteca > Atendimento Serviços de Referência'], [5, 'Biblioteca > Treinamento'], [1, 'Central de Relacionamento > Atendimento Administrativo'], [3, 'Central de Relacionamento > Atendimento Representação Estudantil'], [2, 'Central de Relacionamento > Atendimento Social'], [17, 'Coordenação de Curso > Atendimento Ações Afirmativas'], [15, 'Coordenação de Curso > Atendimento Administrativo'], [19, 'Coordenação de Curso > Atendimento Cultural'], [18, 'Coordenação de Curso > Atendimento Desportivo'], [16, 'Coordenação de Curso > Atendimento Pedagógico'], [20, 'Coordenação de Curso > Atendimento Representação Estudantil'], [33, 'Diretoria de Ensino > Atendimento Administrativo'], [31, 'Diretoria de Ensino > Atendimento Pedagógico'], [34, 'Equipe Pedagógica > Atendimento Administrativo'], [32, 'Equipe Pedagógica > Atendimento Pedagógico'], [35, 'Napne > Atendimento'], [22, 'Neabi > Atendimento Administrativo'], [14, 'Nuged > Atendimento Nutricional'], [10, 'Nuged > Atendimento Pedagógico'], [11, 'Nuged > Atendimento Psicológico'], [9, 'Nuged > Atendimento Representação Estudantil'], [13, 'Nuged > Atendimento Saúde'], [12, 'Nuged > Atendimento Social'], [26, 'Técnico Audiovisual > Atendimento de apoio ao ensino - docente'], [25, 'Técnico Audiovisual > Atendimento de apoio ao ensino - estudante'], [28, 'Técnicos de Laboratório - Área > Atendimento Administrativo'], [30, 'Técnicos de Laboratório - Área > Atendimento de Apoio Pedagógico ao Docente'], [29, 'Técnicos de Laboratório - Área > Atendimento de Apoio Pedagógico ao estudante']
]
</script>

<template>
  <div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4">
    <form :action="action" method="post" class="max-h-[90vh] w-full max-w-3xl overflow-y-auto rounded-lg bg-white p-6 shadow-xl">
      <div class="mb-4 flex items-center justify-between">
        <h2 class="text-xl font-bold">Exportar ocorrência para o Sistema Acadêmico</h2>
        <button type="button" class="text-xl text-gray-500" @click="emit('close')">×</button>
      </div>
      <p class="mb-4 rounded bg-yellow-100 p-3 text-sm text-yellow-800">Este é uma funcionalidade experimental. Certifique-se de estar logado no Sistema Acadêmico antes de enviar os dados.</p>
      <label class="mb-1 block text-sm font-medium" for="atendimento_tipo_id">Selecione o Tipo</label>
      <select id="atendimento_tipo_id" v-model="atendimentoTipoId" name="data[Atendimento][atendimento_tipo_id]" required class="mb-4 w-full rounded border p-2">
        <option value="" disabled>Selecione o Tipo</option>
        <option v-for="tipo in tipos" :key="tipo[0]" :value="tipo[0]">{{ tipo[1] }}</option>
      </select>
      <label class="mb-1 block text-sm font-medium" for="AtendimentoDescricao">Descrição</label>
      <textarea id="AtendimentoDescricao" v-model="descricao" name="data[Atendimento][descricao]" required class="mb-4 min-h-32 w-full rounded border p-2"></textarea>
      <label class="mb-1 block text-sm font-medium" for="AtendimentoData">Data Atendimento</label>
      <input id="AtendimentoData" v-model="dataAtendimento" type="text" name="data[Atendimento][data_atendimento]" maxlength="255" class="mb-4 w-full rounded border p-2" />
      <label class="mb-1 block text-sm font-medium" for="AtendimentoProcessoSuap">Processo SUAP</label>
      <input id="AtendimentoProcessoSuap" v-model="processoSuap" type="text" name="data[Atendimento][processo_suap]" maxlength="255" class="mb-6 w-full rounded border p-2" />
      <div class="flex justify-end gap-2">
        <button type="button" class="rounded border px-4 py-2" @click="emit('close')">Cancelar</button>
        <button type="submit" class="rounded bg-green-600 px-4 py-2 text-white hover:bg-green-700">Salvar</button>
      </div>
    </form>
  </div>
</template>