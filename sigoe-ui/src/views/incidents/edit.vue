<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Select from '@/components/ui/select.vue'
import Header from '@/components/header.vue'

const route = useRoute()
const incidentId = ref(route.params.id)

const breadcrumbItems = [
  { label: "Home", href: "/" },
  { label: "Ocorrências", href: "/ocorrencias" },
  { label: "Ocorrências", href: "/ocorrencias/ocorrencias/listar" },
  { label: "Editar", href: `/ocorrencias/ocorrencias/editar/${incidentId.value}` },
];

const selectedStudent = ref('john_doe');
const selectedStudentType = ref('');
const selectedAssistant = ref('luiz_picolo');
const selectedForwardTo = ref('coordinator');
const selectedOccurrenceType = ref('disciplinary');
const selectedAccessType = ref('public');
const selectedSanction = ref('warning');
const occurrenceResolved = ref('yes');
const occurrenceDate = ref('2025-05-30');
const occurrenceTime = ref('21:47');
const occurrenceDescription = ref('Estudante chegou atrasado na aula e interrompeu a explicação do professor. Demonstrou comportamento inadequado ao questionar a autoridade do docente de forma desrespeitosa.');
const solutionDescription = ref('Foi realizada uma conversa com o estudante sobre a importância do respeito às normas da instituição e aos professores. O estudante demonstrou compreensão e se comprometeu a melhorar seu comportamento.');

const regulations = ref({
  chapter3: [
    { id: 1, text: "I - ser assíduo e pontual em suas atividades acadêmicas", checked: true },
    { id: 2, text: "II - participar efetiva e atentamente das aulas, contribuindo com o ambiente de aprendizagem e com a manutenção do respeito interpessoal", checked: false },
    { id: 3, text: "III - participar, de forma colaborativa e respeitosa, das atividades curriculares e extracurriculares propostas aos discentes", checked: false },
    { id: 4, text: "IV - acompanhar as comunicações internas veiculadas nos quadros de avisos, via e-mail institucional, ou por qualquer outro meio de comunicação oficial", checked: false }
  ],
  chapter4: [
    { id: 1, text: "I - proceder de forma desrespeitosa, provocando ou participando de algazarras ou manifestações que prejudiquem ou interrompam atividades de ensino, pesquisa, extensão e administração", checked: true },
    { id: 2, text: "II - interromper atividades de ensino sem autorização do docente ou da coordenação", checked: true },
    { id: 3, text: "III - utilizar aparelhos eletrônicos, salvo quando devidamente autorizado para realização de atividades que contribuam para os processos de ensino e de aprendizagem", checked: false },
    { id: 4, text: "IV - realizar consulta não autorizada, de qualquer natureza, durante a realização de atividades avaliativas", checked: false }
  ]
});

const handleSubmit = async () => {
  // Implementar lógica de atualização da ocorrência
  alert('Ocorrência atualizada');
}

onMounted(() => {
  // fetchIncident(incidentId.value)
})

// const fetchIncident = async (id) => {
//   try {
//     const response = await findIncident(id)
//     // Preencher os campos com os dados da ocorrência
//   } catch (error) {
//     console.error('Erro ao buscar dados da ocorrência:', error)
//   }
// }
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <!-- Sidebar -->
      <Sidebar :activePage="'ocorrencias'" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">Editar Ocorrência #{{ incidentId }}</h1>

        <form @submit.prevent="handleSubmit" class="space-y-6">
          <div class="p-1 rounded-lg shadow-sm">
            <!-- Student Information Section -->
            <Card customClass="mb-4" title="Estudante">
              <div class="grid grid-cols-6 gap-6 mb-6">
                <div class="col-span-4">
                  <Select
                    id="student"
                    name="student"
                    label="Estudante"
                    v-model="selectedStudent"
                    :options="[
                      { value: '', label: 'Selecione o estudante' },
                      { value: 'john_doe', label: 'John Doe' },
                      { value: 'jane_smith', label: 'Jane Smith' },
                      { value: 'michael_brown', label: 'Michael Brown' },
                      { value: 'emily_davis', label: 'Emily Davis' },
                      { value: 'chris_johnson', label: 'Chris Johnson' }
                    ]"
                  />
                </div>
                <div class="col-span-2">
                  <Select
                    id="studentType"
                    name="studentType"
                    label="Estudante é?"
                    v-model="selectedStudentType"
                    :options="[
                      { value: '', label: 'Não residente' },
                      { value: 'resident', label: 'Residente' },
                      { value: 'external', label: 'Externo' }
                    ]"
                  />
                </div>
              </div>
            </Card>

            <!-- Assistant Section -->
            <Card customClass="mb-4" title="Assistente">
              <div class="grid grid-cols-6 gap-6 mb-6">
                <div class="col-span-3">
                  <Select
                    id="assistant"
                    name="assistant"
                    label="Assistente"
                    v-model="selectedAssistant"
                    :options="[
                      { value: '', label: 'Selecione o assistente' },
                      { value: 'luiz_picolo', label: 'Luiz Picolo' },
                      { value: 'john_doe', label: 'John Doe' },
                      { value: 'jane_smith', label: 'Jane Smith' }
                    ]"
                  />
                </div>
                <div class="col-span-3">
                  <Select
                    id="forwardTo"
                    name="forwardTo"
                    label="Encaminhar para"
                    v-model="selectedForwardTo"
                    :options="[
                      { value: '', label: 'Não enviar notificação' },
                      { value: 'coordinator', label: 'Coordenador' },
                      { value: 'director', label: 'Diretor' }
                    ]"
                  />
                </div>
              </div>
            </Card>

            <!-- Occurrence Details Section -->
            <Card customClass="mb-4" title="Ocorrência">
              <div class="grid grid-cols-12 gap-4 mb-4">
                <div class="col-span-3">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Data ocorrência</label>
                  <Input v-model="occurrenceDate" type="date" />
                </div>
                <div class="col-span-3">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Hora ocorrência</label>
                  <Input v-model="occurrenceTime" type="time" />
                </div>
                <div class="col-span-3">
                  <Select
                    id="occurrenceType"
                    name="occurrenceType"
                    label="Tipos da Ocorrência"
                    v-model="selectedOccurrenceType"
                    :options="[
                      { value: '', label: 'Tipo de Ocorrência' },
                      { value: 'disciplinary', label: 'Disciplinar' },
                      { value: 'academic', label: 'Acadêmica' }
                    ]"
                  />
                </div>
                <div class="col-span-3">
                  <Select
                    id="accessType"
                    name="accessType"
                    label="Tipo de Acesso"
                    v-model="selectedAccessType"
                    :options="[
                      { value: 'public', label: 'Público' },
                      { value: 'private', label: 'Privado' }
                    ]"
                  />
                </div>
              </div>

              <div class="mb-4 text-xs text-gray-600 italic">
                <strong>* Observação:</strong> Ocorrências com tipo de acesso privado somente serão visualizadas por aquele(s) que as criaram. Caso seja necessário que elas sejam acessadas por outros, devem ser marcadas como públicas.
              </div>

              <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-1">Ocorrência</label>
                <textarea 
                  v-model="occurrenceDescription"
                  class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm"
                  rows="6"
                ></textarea>
              </div>

              <div class="grid grid-cols-6 gap-6 mb-4">
                <div class="col-span-3">
                  <Select
                    id="sanction"
                    name="sanction"
                    label="Sanção aplicada"
                    v-model="selectedSanction"
                    :options="[
                      { value: '', label: 'Sanção aplicada' },
                      { value: 'warning', label: 'Advertência' },
                      { value: 'suspension', label: 'Suspensão' }
                    ]"
                  />
                </div>
                <div class="col-span-3">
                  <Select
                    id="resolved"
                    name="resolved"
                    label="Ocorrência resolvida?"
                    v-model="occurrenceResolved"
                    :options="[
                      { value: 'no', label: 'Não' },
                      { value: 'yes', label: 'Sim' }
                    ]"
                  />
                </div>
              </div>
            </Card>

            <!-- Disciplinary Regulations Section 1 -->
            <Card customClass="mb-4">
              <div class="mb-2">
                <p class="font-medium">Segundo o Capítulo III, Art 4° que trata sobre os direitos e deveres do estudante ( <a href="#" class="text-blue-600 hover:underline">Acesse aqui o Regulamento Disciplinar Discente</a> )</p>
              </div>
              
              <div class="space-y-2 mb-4">
                <div v-for="regulation in regulations.chapter3" :key="regulation.id" class="flex items-start">
                  <input v-model="regulation.checked" type="checkbox" class="mt-1 mr-2" />
                  <span class="text-sm">{{ regulation.text }}</span>
                </div>
              </div>
            </Card>

            <!-- Disciplinary Regulations Section 2 -->
            <Card customClass="mb-4">
              <div class="mb-2">
                <p class="font-medium">Segundo o Capítulo IV que trata sobre as proibições e responsabilidades ( <a href="#" class="text-blue-600 hover:underline">Acesse aqui o Regulamento Disciplinar Discente</a> )</p>
              </div>
              
              <div class="space-y-2 mb-4">
                <div v-for="regulation in regulations.chapter4" :key="regulation.id" class="flex items-start">
                  <input v-model="regulation.checked" type="checkbox" class="mt-1 mr-2" />
                  <span class="text-sm">{{ regulation.text }}</span>
                </div>
              </div>
            </Card>

            <!-- Solution Description -->
            <Card customClass="mb-4">
              <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-1">Descrição da solução</label>
                <textarea 
                  v-model="solutionDescription"
                  class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm"
                  rows="6"
                  placeholder="Solução"
                ></textarea>
              </div>
            </Card>
          </div>

          <div class="flex justify-start gap-2">
            <Button customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500">
              <i class="fa-solid fa-save mr-1"></i>
              Atualizar
            </Button>
            <Button :to="`/ocorrencias/ocorrencias/visualizar/${incidentId}`" customClass="bg-white border-gray-200 !text-gray-900 hover:bg-gray-100 !focus:ring-gray-300">
              <i class="fa-solid fa-times mr-1"></i>
              Cancelar
            </Button>
          </div>
        </form>

      </main>
    </div>
  </div>
</template>
