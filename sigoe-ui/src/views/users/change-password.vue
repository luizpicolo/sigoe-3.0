<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'
import Input from '@/components/ui/input.vue'
import Alert from '@/components/ui/alert.vue'
import Header from '@/components/header.vue'

const router = useRouter()

const breadcrumbItems = [
  { label: "Home", href: "/home" },
  { label: "Trocar Senha", href: "/trocar-senha" },
];

const currentPassword = ref('');
const newPassword = ref('');
const confirmPassword = ref('');
const isSubmitting = ref(false);
const errorMessage = ref('');
const successMessage = ref('');

const handleSubmit = async (event) => {
  event.preventDefault()
  
  // Reset messages
  errorMessage.value = '';
  successMessage.value = '';
  
  // Validate form
  if (!currentPassword.value) {
    errorMessage.value = 'Por favor, informe sua senha atual.';
    return;
  }
  
  if (!newPassword.value) {
    errorMessage.value = 'Por favor, informe a nova senha.';
    return;
  }
  
  if (newPassword.value.length < 8) {
    errorMessage.value = 'A nova senha deve ter pelo menos 8 caracteres.';
    return;
  }
  
  if (newPassword.value === currentPassword.value) {
    errorMessage.value = 'A nova senha deve ser diferente da senha atual.';
    return;
  }
  
  if (newPassword.value !== confirmPassword.value) {
    errorMessage.value = 'A confirmação da senha não corresponde à nova senha.';
    return;
  }
  
  // Submit form
  isSubmitting.value = true;
  
  try {
    // Simulação de chamada de API
    await new Promise(resolve => setTimeout(resolve, 1000));
    
    // Sucesso
    successMessage.value = 'Senha alterada com sucesso!';
    currentPassword.value = '';
    newPassword.value = '';
    confirmPassword.value = '';
  } catch (error) {
    console.error('Erro ao alterar senha:', error);
    errorMessage.value = 'Erro ao alterar a senha. Por favor, tente novamente.';
  } finally {
    isSubmitting.value = false;
  }
};

const dismissError = () => {
  errorMessage.value = '';
}

const dismissSuccess = () => {
  successMessage.value = '';
}
</script>

<template>
  <div class="min-h-screen flex flex-col">
    <Header />

    <div class="flex flex-col md:flex-row flex-1">
      <!-- Sidebar -->
      <Sidebar :activePage="'trocar-senha'" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-6">Trocar Senha</h1>

        <div class="max-w-full">
          <Card title="Alterar Senha" icon="lock" customClass="mb-6">
            <Alert 
              v-if="errorMessage"
              type="error"
              :message="errorMessage"
              dismissible
              @dismiss="dismissError"
              class="mb-4"
            />

            <Alert 
              v-if="successMessage"
              type="success"
              :message="successMessage"
              dismissible
              @dismiss="dismissSuccess"
              class="mb-4"
            />

            <form @submit="handleSubmit" class="space-y-6">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Senha Atual</label>
                <Input 
                  v-model="currentPassword"
                  type="password"
                  placeholder="Digite sua senha atual"
                  required
                />
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Nova Senha</label>
                <Input 
                  v-model="newPassword"
                  type="password"
                  placeholder="Digite a nova senha"
                  required
                />
                <p class="mt-1 text-xs text-gray-500">A senha deve ter pelo menos 8 caracteres.</p>
              </div>
              
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Confirmar Nova Senha</label>
                <Input 
                  v-model="confirmPassword"
                  type="password"
                  placeholder="Confirme a nova senha"
                  required
                />
              </div>
              
              <div class="flex justify-end">
                <button
                  type="submit"
                  :disabled="isSubmitting"
                  class="justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white focus:outline-none focus:ring-2 focus:ring-offset-2 bg-green-600 hover:bg-green-700 focus:ring-green-500 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <i v-if="isSubmitting" class="fa-solid fa-spinner fa-spin mr-2"></i>
                  <i v-else class="fa-solid fa-save mr-2"></i>
                  {{ isSubmitting ? 'Alterando...' : 'Alterar Senha' }}
                </button>
              </div>
            </form>
          </Card>

          <Card title="Dicas de Segurança" icon="shield" customClass="bg-blue-50 border-blue-200">
            <ul class="space-y-2 text-sm text-gray-700">
              <li class="flex items-start">
                <i class="fa-solid fa-check-circle text-blue-600 mr-2 mt-0.5"></i>
                <span>Use uma combinação de letras maiúsculas, minúsculas, números e símbolos.</span>
              </li>
              <li class="flex items-start">
                <i class="fa-solid fa-check-circle text-blue-600 mr-2 mt-0.5"></i>
                <span>Evite usar informações pessoais como datas de nascimento ou nomes.</span>
              </li>
              <li class="flex items-start">
                <i class="fa-solid fa-check-circle text-blue-600 mr-2 mt-0.5"></i>
                <span>Não use a mesma senha em diferentes sistemas ou sites.</span>
              </li>
              <li class="flex items-start">
                <i class="fa-solid fa-check-circle text-blue-600 mr-2 mt-0.5"></i>
                <span>Troque sua senha periodicamente para maior segurança.</span>
              </li>
            </ul>
          </Card>
        </div>
      </main>
    </div>
  </div>
</template>
