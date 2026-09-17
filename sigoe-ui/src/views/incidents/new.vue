<script setup>
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Input from '@/components/ui/input.vue'
import Card from '@/components/ui/card.vue'
import Select from '@/components/ui/select.vue'

import { ref } from 'vue'

const breadcrumbItems = [
  { label: "Home", href: "/" },
  { label: "Administrador", href: "/" },
  { label: "Ocorrências", href: "/ocorrencias/ocorrencias/listar" },
  { label: "Nova", href: "/ocorrencias/ocorrencias/nova" },
];

const page = ref(1);

const handleSubmit = async (event) => {
  event.preventDefault()
  page.value = newPage;
  console.log(`Page updated to: ${newPage}`);
};

const selectedStudent = ref('');
const selectedStudentType = ref('');
const selectedAssistant = ref('');
const selectedForwardTo = ref('');
const selectedOccurrenceType = ref('');
const selectedAccessType = ref('');
const selectedSanction = ref('');
const occurrenceResolved = ref('');
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <!-- Header -->
    <header class="bg-white border-b border-gray-200 py-2 px-4 flex justify-between items-center">
      <div class="flex items-center">
        <img src="/logo_ifms.png" width="160">
      </div>
      <div class="text-sm">
        SIGOE - Controle de ocorrências escolares - <span class="text-green-600">Sair</span>
      </div>
    </header>

    <div class="flex flex-col md:flex-row flex-1">
      <!-- Sidebar -->
      <Sidebar :activePage="'ocorrencias'" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">Cadastrar Nova Ocorrência</h1>

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
                      { value: '', label: 'Luiz Picolo' },
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
                  <Input type="date" placeholder="30/05/2025" />
                </div>
                <div class="col-span-3">
                  <label class="block text-sm font-medium text-gray-700 mb-1">Hora ocorrência</label>
                  <Input type="time" placeholder="21:47" />
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
                      { value: '', label: 'Público' },
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
                      { value: '', label: 'Não' },
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
                <div class="flex items-start">
                  <input type="checkbox" class="mt-1 mr-2" />
                  <span class="text-sm">I - ser assíduo e pontual em suas atividades acadêmicas</span>
                </div>
                <div class="flex items-start">
                  <input type="checkbox" class="mt-1 mr-2" />
                  <span class="text-sm">II - participar efetiva e atentamente das aulas, contribuindo com o ambiente de aprendizagem e com a manutenção do respeito interpessoal</span>
                </div>
                <div class="flex items-start">
                  <input type="checkbox" class="mt-1 mr-2" />
                  <span class="text-sm">III - participar, de forma colaborativa e respeitosa, das atividades curriculares e extracurriculares propostas aos discentes</span>
                </div>
                <div class="flex items-start">
                  <input type="checkbox" class="mt-1 mr-2" />
                  <span class="text-sm">IV - acompanhar as comunicações internas veiculadas nos quadros de avisos, via e-mail institucional, ou por qualquer outro meio de comunicação oficial</span>
                </div>
              </div>
            </Card>

            <!-- Disciplinary Regulations Section 2 -->
            <Card customClass="mb-4">
              <div class="mb-2">
                <p class="font-medium">Segundo o Capítulo IV que trata sobre as proibições e responsabilidades ( <a href="#" class="text-blue-600 hover:underline">Acesse aqui o Regulamento Disciplinar Discente</a> )</p>
              </div>
              
              <div class="space-y-2 mb-4">
                <div class="flex items-start">
                  <input type="checkbox" class="mt-1 mr-2" />
                  <span class="text-sm">I - proceder de forma desrespeitosa, provocando ou participando de algazarras ou manifestações que prejudiquem ou interrompam atividades de ensino, pesquisa, extensão e administração</span>
                </div>
                <div class="flex items-start">
                  <input type="checkbox" class="mt-1 mr-2" />
                  <span class="text-sm">II - interromper atividades de ensino sem autorização do docente ou da coordenação</span>
                </div>
                <div class="flex items-start">
                  <input type="checkbox" class="mt-1 mr-2" />
                  <span class="text-sm">III - utilizar aparelhos eletrônicos, salvo quando devidamente autorizado para realização de atividades que contribuam para os processos de ensino e de aprendizagem</span>
                </div>
                <div class="flex items-start">
                  <input type="checkbox" class="mt-1 mr-2" />
                  <span class="text-sm">IV - realizar consulta não autorizada, de qualquer natureza, durante a realização de atividades avaliativas</span>
                </div>
              </div>
            </Card>

            <!-- Solution Description -->
            <Card customClass="mb-4">
              <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-1">Descrição da solução</label>
                <textarea 
                  class="block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm"
                  rows="6"
                  placeholder="Solução"
                ></textarea>
              </div>
            </Card>
          </div>

          <div class="flex justify-start">
            <Button customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500">
              <i class="fa-solid fa-save mr-1"></i>
              Salvar
            </Button>
          </div>
        </form>

      </main>
    </div>
  </div>
</template>
