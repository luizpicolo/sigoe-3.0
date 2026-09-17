<script setup>
import { ref, computed } from 'vue'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Select from '@/components/ui/select.vue'
import Header from '@/components/header.vue'

const breadcrumbItems = [
  { label: "Home", href: "/" },
  { label: "Ocorrências", href: "/ocorrencias" },
  { label: "Relatório ocorrências", href: "/ocorrencias/relatorio" },
];

// Form data
const selectedStudent = ref('');
const selectedCourse = ref('');
const selectedClass = ref('');
const selectedOccurrenceType = ref('');
const selectedResident = ref('');
const selectedStatus = ref('');
const selectedResolved = ref('');
const selectedCampus = ref('');
const startDate = ref('');
const endDate = ref('');
const isGenerating = ref(false);

// Computed properties
const isFormValid = computed(() => {
  return startDate.value && endDate.value;
});

const hasFilters = computed(() => {
  return selectedStudent.value || selectedCourse.value || selectedClass.value || 
         selectedOccurrenceType.value || selectedResident.value || selectedStatus.value ||
         selectedResolved.value || selectedCampus.value || startDate.value || endDate.value;
});

// Methods
const handleGenerateReport = async () => {
  if (!isFormValid.value) {
    alert('Por favor, selecione pelo menos as datas de início e fim.');
    return;
  }

  isGenerating.value = true;
  
  try {
    // Simular geração de relatório
    await new Promise(resolve => setTimeout(resolve, 2000));
    
    console.log('Gerando relatório com os filtros:', {
      student: selectedStudent.value,
      course: selectedCourse.value,
      class: selectedClass.value,
      occurrenceType: selectedOccurrenceType.value,
      resident: selectedResident.value,
      status: selectedStatus.value,
      resolved: selectedResolved.value,
      campus: selectedCampus.value,
      startDate: startDate.value,
      endDate: endDate.value
    });
    
    alert('Relatório gerado com sucesso!');
  } catch (error) {
    alert('Erro ao gerar relatório. Tente novamente.');
  } finally {
    isGenerating.value = false;
  }
}

const clearFilters = () => {
  selectedStudent.value = '';
  selectedCourse.value = '';
  selectedClass.value = '';
  selectedOccurrenceType.value = '';
  selectedResident.value = '';
  selectedStatus.value = '';
  selectedResolved.value = '';
  selectedCampus.value = '';
  startDate.value = '';
  endDate.value = '';
}

const setQuickFilter = (days) => {
  const today = new Date();
  const pastDate = new Date();
  pastDate.setDate(today.getDate() - days);
  
  endDate.value = today.toISOString().split('T')[0];
  startDate.value = pastDate.toISOString().split('T')[0];
}
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <!-- Sidebar -->
      <Sidebar :activePage="'relatorio'" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <div class="flex justify-between items-center mb-6">
          <h1 class="text-2xl font-bold">Relatório de Ocorrências</h1>
          <div class="flex gap-2">
            <Button 
              v-if="hasFilters"
              @click="clearFilters"
              customClass="bg-gray-500 hover:bg-gray-600 focus:ring-gray-500"
            >
              <i class="fa-solid fa-eraser mr-1"></i>
              Limpar Filtros
            </Button>
          </div>
        </div>

        <!-- Quick Filters -->
        <Card customClass="mb-4" title="Filtros Rápidos" icon="filter">
          <div class="flex flex-wrap gap-2">
            <Button 
              @click="setQuickFilter(7)"
              customClass="bg-blue-500 hover:bg-blue-600 focus:ring-blue-500 text-sm"
            >
              Últimos 7 dias
            </Button>
            <Button 
              @click="setQuickFilter(30)"
              customClass="bg-blue-500 hover:bg-blue-600 focus:ring-blue-500 text-sm"
            >
              Últimos 30 dias
            </Button>
            <Button 
              @click="setQuickFilter(90)"
              customClass="bg-blue-500 hover:bg-blue-600 focus:ring-blue-500 text-sm"
            >
              Últimos 3 meses
            </Button>
            <Button 
              @click="setQuickFilter(365)"
              customClass="bg-blue-500 hover:bg-blue-600 focus:ring-blue-500 text-sm"
            >
              Último ano
            </Button>
          </div>
        </Card>

        <form @submit.prevent="handleGenerateReport" class="space-y-6">
          <!-- Filtros de Data -->
          <Card customClass="mb-4" title="Período *" icon="calendar">
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Data início *</label>
                <Input 
                  v-model="startDate"
                  type="date"
                  placeholder="Data início"
                  required
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Data final *</label>
                <Input 
                  v-model="endDate"
                  type="date"
                  placeholder="Data fim"
                  required
                />
              </div>
            </div>
          </Card>

          <!-- Filtros de Estudante e Curso -->
          <Card customClass="mb-4" title="Estudante e Curso" icon="user-graduate">
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Estudante</label>
                <Select
                  id="student"
                  name="student"
                  v-model="selectedStudent"
                  :options="[
                    { value: '', label: 'Todos os estudantes' },
                    { value: 'john_doe', label: 'John Doe' },
                    { value: 'jane_smith', label: 'Jane Smith' },
                    { value: 'michael_brown', label: 'Michael Brown' },
                    { value: 'emily_davis', label: 'Emily Davis' },
                    { value: 'chris_johnson', label: 'Chris Johnson' }
                  ]"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Campus</label>
                <Select
                  id="campus"
                  name="campus"
                  v-model="selectedCampus"
                  :options="[
                    { value: '', label: 'Todos os campus' },
                    { value: 'nova_andradina', label: 'Nova Andradina' },
                    { value: 'campo_grande', label: 'Campo Grande' },
                    { value: 'tres_lagoas', label: 'Três Lagoas' }
                  ]"
                />
              </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Curso</label>
                <Select
                  id="course"
                  name="course"
                  v-model="selectedCourse"
                  :options="[
                    { value: '', label: 'Todos os cursos' },
                    { value: 'informatica', label: 'Curso Técnico em Informática' },
                    { value: 'administracao', label: 'Curso Técnico em Administração' },
                    { value: 'agropecuaria', label: 'Curso Técnico em Agropecuária' }
                  ]"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Turma</label>
                <Select
                  id="class"
                  name="class"
                  v-model="selectedClass"
                  :options="[
                    { value: '', label: 'Todas as turmas' },
                    { value: '2024A', label: '2024A' },
                    { value: '2024B', label: '2024B' },
                    { value: '2025A', label: '2025A' }
                  ]"
                />
              </div>
            </div>
          </Card>

          <!-- Filtros de Ocorrência -->
          <Card customClass="mb-4" title="Dados da Ocorrência" icon="exclamation-triangle">
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Tipo de Ocorrência</label>
                <Select
                  id="occurrenceType"
                  name="occurrenceType"
                  v-model="selectedOccurrenceType"
                  :options="[
                    { value: '', label: 'Todos os tipos' },
                    { value: 'disciplinary', label: 'Disciplinar' },
                    { value: 'academic', label: 'Acadêmica' },
                    { value: 'behavioral', label: 'Comportamental' }
                  ]"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Residente?</label>
                <Select
                  id="resident"
                  name="resident"
                  v-model="selectedResident"
                  :options="[
                    { value: '', label: 'Todos' },
                    { value: 'yes', label: 'Sim' },
                    { value: 'no', label: 'Não' }
                  ]"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
                <Select
                  id="status"
                  name="status"
                  v-model="selectedStatus"
                  :options="[
                    { value: '', label: 'Todos' },
                    { value: 'active', label: 'Ativo' },
                    { value: 'archived', label: 'Arquivado' }
                  ]"
                />
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Resolvida?</label>
                <Select
                  id="resolved"
                  name="resolved"
                  v-model="selectedResolved"
                  :options="[
                    { value: '', label: 'Todas' },
                    { value: 'yes', label: 'Sim' },
                    { value: 'no', label: 'Não' }
                  ]"
                />
              </div>
            </div>
          </Card>

          <!-- Resumo dos Filtros -->
          <Card v-if="hasFilters" customClass="mb-4 bg-blue-50 border-blue-200" title="Filtros Aplicados" icon="filter">
            <div class="flex flex-wrap gap-2">
              <span v-if="startDate" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                De: {{ new Date(startDate).toLocaleDateString('pt-BR') }}
              </span>
              <span v-if="endDate" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800">
                Até: {{ new Date(endDate).toLocaleDateString('pt-BR') }}
              </span>
              <span v-if="selectedStudent" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
                Estudante selecionado
              </span>
              <span v-if="selectedCourse" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                Curso selecionado
              </span>
              <span v-if="selectedOccurrenceType" class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                Tipo: {{ selectedOccurrenceType }}
              </span>
            </div>
          </Card>

          <!-- Botões de Ação -->
          <div class="flex justify-start gap-3">
            <Button 
              :disabled="!isFormValid || isGenerating"
              customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <i v-if="!isGenerating" class="fa-solid fa-chart-bar mr-1"></i>
              <i v-else class="fa-solid fa-spinner fa-spin mr-1"></i>
              {{ isGenerating ? 'Gerando...' : 'Gerar relatório' }}
            </Button>
            
            <Button 
              type="button"
              :disabled="!isFormValid"
              customClass="bg-blue-600 hover:bg-blue-700 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <i class="fa-solid fa-eye mr-1"></i>
              Visualizar
            </Button>
            
            <Button 
              type="button"
              :disabled="!isFormValid"
              customClass="bg-orange-600 hover:bg-orange-700 focus:ring-orange-500 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <i class="fa-solid fa-download mr-1"></i>
              Exportar PDF
            </Button>
          </div>

          <!-- Informações de Ajuda -->
          <Card customClass="bg-gray-50 border-gray-200" title="Dicas para gerar relatórios" icon="info-circle">
            <div class="flex items-start">
              <i class="fa-solid fa-info-circle text-blue-500 mt-1 mr-3"></i>
              <div>
                <h3 class="text-sm font-medium text-gray-700 mb-1">Dicas para gerar relatórios</h3>
                <ul class="text-xs text-gray-600 space-y-1">
                  <li>• As datas de início e fim são obrigatórias</li>
                  <li>• Use os filtros rápidos para períodos comuns</li>
                  <li>• Deixe os campos em branco para incluir todos os registros daquela categoria</li>
                  <li>• O relatório será gerado em formato PDF por padrão</li>
                </ul>
              </div>
            </div>
          </Card>
        </form>

      </main>
    </div>
  </div>
</template>
