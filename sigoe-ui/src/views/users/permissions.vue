<script setup>
import Sidebar from '@/components/sidebar.vue'
import Button from '@/components/ui/button.vue'
import Breadcrumb from '@/components/breadcrumb.vue'
import Card from '@/components/ui/card.vue'

const breadcrumbItems = [
  { label: "Home", href: "/" },
  { label: "Administrador", href: "/administrador" },
  { label: "Usuários", href: "/administrador/usuarios" },
  { label: "Visualizar", href: "/administrador/usuarios/visualizar" },
];

const availableEntities = [
    { id: "users", name: "Usuários" },
    { id: "students", name: "Estudantes" },
    { id: "courses", name: "Cursos" },
    { id: "classes", name: "Turmas" },
    { id: "occurrences", name: "Ocorrências" },
    { id: "reports", name: "Relatórios" },
    { id: "dashboard", name: "Dashboard" },
  ]
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
      <Sidebar :activePage="'usuarios'" />

      <!-- Main Content -->
      <main class="flex-1 p-6">
        <Breadcrumb :items="breadcrumbItems" />

        <h1 class="text-2xl font-bold mb-1">Gerenciar Permissoes</h1>

        <div class="flex justify-end">
          <Button to="/administrador/usuarios/listar" customClass="bg-white border-gray-200 !text-gray-900 hover:bg-gray-100 !focus:ring-gray-300">
            <i class="fa-solid fa-arrow-left"></i>
            Voltar
          </Button>
        </div>

        <div class="mb-6 mt-4 rounded-lg shadow-sm">
          <Card title="Permissões de Luiz F Picolo">
            <p>Configure as permissões de acesso para cada entidade do sistema. Selecione as entidades e defina quais operações o usuário poderá realizar.</p>
            <div class="grid grid-cols-7 gap-2 mb-6 mt-4">
              <div class="col-span-6">
                <label for="entity-select" class="block text-sm font-medium text-gray-700 mb-1">
                  Adicionar entidade
                </label>
                <select
                    class="block w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-green-500 focus:border-green-500 sm:text-sm">
                  <option value="" disabled>Selecione uma entidade</option>
                  <option v-for="entity in availableEntities" :key="entity.id" :value="entity.id">
                    {{ entity.name }}
                  </option>
                </select>
              </div>
              <div class="col-span-1 mt-2">
                <Button to="#" customClass="mt-4 w-full bg-green-600 hover:bg-green-700 focus:ring-green-500">
                  Adicionar  
                </Button>
              </div>
              
            </div>

            <table class="mt-4 min-w-full divide-y divide-gray-200">
              <thead class="bg-gray-100">
                <tr>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Entidade
                  </th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Criar
                  </th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Ler
                  </th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Leitura Restrita
                  </th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Atualizar
                  </th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Deletar
                  </th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Opções extras
                  </th>
                  <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Ações
                  </th>
                </tr>
              </thead>
              <tbody v-for="(value, i) in 2" class="bg-white divide-y divide-gray-200">
                <tr>
                  <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Usuários</td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-center text-gray-500">
                    <input type="checkbox" name="Administrador" checked class="w-5 h-5" />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-center text-gray-500">
                    <input type="checkbox" name="Administrador" checked class="w-5 h-5" />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-center text-gray-500">
                    <input type="checkbox" name="Administrador" checked class="w-5 h-5" />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-center text-gray-500">
                    <input type="checkbox" name="Administrador" checked class="w-5 h-5" />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-center text-gray-500">
                    <input type="checkbox" name="Administrador" checked class="w-5 h-5" />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-center text-gray-500">
                    <input type="checkbox" name="Administrador" checked class="w-5 h-5" />
                  </td>
                  <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    <Button customClass="w-full bg-red-600 hover:bg-red-700 focus:ring-red-500" to="/administrador/usuarios/visualizar/9">
                      <i class="fa-solid fa-trash-alt"></i>
                      Deletar
                    </Button>
                  </td>
                </tr>
              </tbody>
            </table>
            <!-- Legenda -->
            <div class="bg-gray-50 p-4 rounded-md border border-gray-200">
              <h3 class="text-sm font-medium text-gray-700 mb-2">Legenda:</h3>
              <ul class="space-y-1 text-sm text-gray-600">
              <li>
                <strong>Criar:</strong> Permissão para criar novos registros
              </li>
              <li>
                <strong>Ler:</strong> Permissão para visualizar todos os registros
              </li>
              <li>
                <strong>Leitura Restrita:</strong> Permissão para visualizar apenas registros específicos
              </li>
              <li>
                <strong>Atualizar:</strong> Permissão para editar registros existentes
              </li>
              <li>
                <strong>Deletar:</strong> Permissão para excluir registros
              </li>
              <li>
                <strong>Opções extras:</strong> Permissões adicionais específicas da entidade
              </li>
              </ul>
            </div>

            <div class="flex justify-end mt-4">
              <Button to="#" customClass="bg-green-600 hover:bg-green-700 focus:ring-green-500">
                <i class="fa-solid fa-save mr-1"></i>
                Salvar Permissões
              </Button>
            </div>
          </Card>
        </div>
      </main>
    </div>
  </div>
</template>