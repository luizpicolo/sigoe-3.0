<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { error, success, confirm } from '@/utils/sweetPopup2'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Header from '@/components/header.vue'
import AcademicExportForm from '@/components/incidents/academic-export-form.vue'
import { formatDate, formatTime } from '@/utils'
import { can } from '@/services/permissions'
import { find, remove } from '@/services/incidents'

const route = useRoute()
const router = useRouter()
const incidentId = route.params.id
const loading = ref(true)
const incident = ref(null)
const showAcademicExportForm = ref(false)
const academicExportAction = ref('')

const sanctionLabels = {
  verbal_warning: 'Advertência Verbal',
  written_warning: 'Advertência escrita',
  suspension: 'Suspensão',
  quitting_school: 'Desligamento'
}

const breadcrumbItems = [
  { label: 'Home', href: '/' },
  { label: 'Ocorrências', href: '/ocorrencias' },
  { label: 'Ocorrências', href: '/ocorrencias/ocorrencias/listar' },
  { label: 'Visualizar', href: `/ocorrencias/ocorrencias/visualizar/${incidentId}` }
]

const loadIncident = async () => {
  try {
    const response = await find(incidentId)

    incident.value = response.incident

    academicExportAction.value = `https://academico.ifms.edu.br/administrativo/atendimentos/adicionar/${incident.value.student?.ra || ''}/${incident.value.student?.registration_id || ''}`
  } catch (exception) {
    error('Não foi possível carregar a ocorrência.')
  } finally {
    loading.value = false
  }
}

const openAcademicExportForm = () => {
  showAcademicExportForm.value = true
}

const closeAcademicExportForm = () => {
  showAcademicExportForm.value = false
}

const deleteIncident = async () => {
  if (await confirm('Excluir ocorrência?')) {
    try {
      await remove(incidentId)

      success('Ocorrência excluída com sucesso.')
      await router.push('/ocorrencias/ocorrencias/listar')
    } catch (e) {
      error(e.response?.data?.errors?.join(', ') || 'Erro ao excluir ocorrência.')
    }
  }
}

onMounted(loadIncident)
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <Sidebar :activePage="'ocorrencias'" />

      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <div v-if="loading" class="py-8 text-center">
          Carregando ocorrência...
        </div>

        <template v-else>
          <h1 class="text-2xl font-bold mb-1">
            Detalhes da Ocorrência #{{ incident.id }}
          </h1>

          <div class="flex justify-end">
            <Button to="/ocorrencias/ocorrencias/listar" customClass="bg-white border-gray-200 !text-gray-900">
              <i class="fa-solid fa-arrow-left"></i>
              Voltar
            </Button>
          </div>

          <div class="grid grid-cols-4 gap-4 mb-6 mt-4 rounded-lg shadow-sm">
            <Card customClass="col-span-1" title="Estudante">
              <div class="flex justify-center items-center mt-5 pt-2 pb-5">
                <img :src="incident.student?.photo || '/placeholder.svg?height=200&width=200'" width="200" alt="Foto do estudante" />
              </div>

              <div class="text-center">
                <h3 class="font-medium text-gray-900">
                  {{ incident.student?.name }}
                </h3>

                <p class="text-sm text-gray-500">
                  {{ incident.course?.name }}
                </p>

                <p class="text-sm text-gray-500">
                  R.A.: {{ incident.student?.ra || 'Não informado' }}
                </p>

                <p class="text-sm text-gray-500">
                  Campus: {{ incident.course?.polo?.name || 'Não informado' }}
                </p>
              </div>
            </Card>

            <Card customClass="col-span-3" title="Informações da Ocorrência">
              <dl class="divide-y divide-gray-200">
                <div v-for="item in [{ label: 'Data da ocorrência', value: formatDate(incident.date_incident) }, { label: 'Horário', value: formatTime(incident.time_incident) }, { label: 'Tipo de ocorrência', value: incident.type_incident?.name }, { label: 'Tipo de acesso', value: incident.visibility ? 'Público' : 'Privado' }, { label: 'Assistente responsável', value: incident.assistant?.name || incident.user?.name }, { label: 'Encaminhado para', value: incident.sector_id || 'Não encaminhado' }]" :key="item.label" class="py-3 grid grid-cols-3">
                  <dt class="text-sm font-medium text-gray-500">
                    {{ item.label }}
                  </dt>

                  <dd class="text-sm text-gray-900 col-span-2">
                    {{ item.value }}
                  </dd>
                </div>
              </dl>
            </Card>

            <Card customClass="col-span-1" title="Ações">
              <Button :disabled="!can('occurrences', 'update')" customClass="mt-4 w-full bg-blue-600 hover:bg-blue-700" :to="`/ocorrencias/ocorrencias/editar/${incidentId}`">
                <i class="fa-solid fa-edit"></i>
                Editar Ocorrência
              </Button>

              <Button :disabled="!can('occurrences', 'read')" to="/ocorrencias/relatorio" customClass="mt-4 w-full bg-green-600 hover:bg-green-700">
                <i class="fa-solid fa-print"></i>
                Imprimir Relatório
              </Button>

              <Button :disabled="!can('occurrences', 'can_export_to_academic_system')" customClass="mt-4 w-full bg-purple-600 hover:bg-purple-700" @click="openAcademicExportForm">
                <i class="fa-solid fa-file-export"></i>
                Exportar para Sistema Acadêmico
              </Button>

              <Button :disabled="!can('occurrences', 'destroy')" customClass="mt-4 w-full bg-red-600 hover:bg-red-700" @click="deleteIncident">
                <i class="fa-solid fa-trash-alt"></i>
                Excluir Ocorrência
              </Button>
            </Card>

            <template v-if="can('occurrences', 'sanction')">
              <Card customClass="col-span-3" title="Status da Ocorrência">
                <dl class="divide-y divide-gray-200">
                  <div v-for="item in [{ label: 'Sanção aplicada', value: sanctionLabels[incident.sanction] || 'Nenhuma sanção aplicada' }, { label: 'Ocorrência resolvida', value: incident.is_resolved ? 'Sim' : 'Não' }, { label: 'Visibilidade', value: incident.visibility ? 'Visível' : 'Oculta' }, { label: 'Verificada', value: incident.signed_in ? 'Verificada' : 'Pendente' }]" :key="item.label" class="py-3 grid grid-cols-3">
                    <dt class="text-sm font-medium text-gray-500">
                      {{ item.label }}
                    </dt>

                    <dd class="text-sm text-gray-900 col-span-2">
                      {{ item.value }}
                    </dd>
                  </div>
                </dl>
              </Card>

              <Card customClass="col-span-4" title="Descrição da Ocorrência">
                <div class="bg-gray-50 p-4 rounded-md">
                  <p class="text-sm text-gray-700 whitespace-pre-wrap">
                    {{ incident.description }}
                  </p>
                </div>
              </Card>

              <Card customClass="col-span-2" title="Capítulo III - Direitos e Deveres">
                <div class="space-y-2">
                  <div v-for="item in incident.student_duties" :key="item.id" class="flex items-start">
                    <i class="fa-solid fa-check-circle text-green-600 mt-1 mr-2"></i>
                    <span class="text-sm">
                      {{ item.item }}
                    </span>
                  </div>

                  <p v-if="!incident.student_duties?.length" class="text-sm text-gray-500">
                    Nenhum item selecionado.
                  </p>
                </div>
              </Card>

              <Card customClass="col-span-2" title="Capítulo IV - Proibições">
                <div class="space-y-2">
                  <div v-for="item in incident.prohibition_and_responsibilities" :key="item.id" class="flex items-start">
                    <i class="fa-solid fa-check-circle text-red-600 mt-1 mr-2"></i>
                    <span class="text-sm">
                      {{ item.item }}
                    </span>
                  </div>

                  <p v-if="!incident.prohibition_and_responsibilities?.length" class="text-sm text-gray-500">
                    Nenhum item selecionado.
                  </p>
                </div>
              </Card>

              <Card customClass="col-span-4" title="Descrição da Solução">
                <div class="bg-gray-50 p-4 rounded-md">
                  <p class="text-sm text-gray-700 whitespace-pre-wrap">
                    {{ incident.soluction || 'Nenhuma solução descrita ainda.' }}
                  </p>
                </div>
              </Card>
            </template>
          </div>
        </template>
      </main>
    </div>

    <AcademicExportForm v-if="showAcademicExportForm" :incident="incident" :action="academicExportAction" @close="closeAcademicExportForm" />
  </div>
</template>