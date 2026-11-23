# SIGOE - Sistema Integrado de Gestão de Ocorrências Escolares

O **SIGOE** é um sistema para gestão de ocorrências escolares, desenvolvido para apoiar a administração, a mediação pedagógica e o acompanhamento de registros disciplinares no Instituto Federal de Mato Grosso do Sul (IFMS). O software foi desenvolvido inicialmente a partir de um Trabalho de Conclusão de Curso e hoje é utilizado ativamente nos campi da instituição.

---

## 📖 Documentação e Tutorial de Uso

A documentação completa do projeto, abrangendo todas as funcionalidades do sistema, guias passo a passo e manuais detalhados, encontra-se disponível no diretório **`docs/`**:

* **[Tutorial Completo do Usuário (Passo a Passo)](./docs/tutorial-usuario.md)**: Manual detalhado para usuários finais, assistentes de alunos, professores e coordenadores.
* **[Índice Geral da Documentação](./docs/README.md)**: Visão estruturada e referências a cada módulo.

### Módulos Documentados:
1. **[Autenticação e Perfil](./docs/funcionalidades/01-autenticacao-e-perfil.md)**: Login, controle de sessão JWT e alteração de senha.
2. **[Dashboard Gerencial](./docs/funcionalidades/02-dashboard.md)**: Indicadores em tempo real e gráficos estatísticos.
3. **[Gestão de Ocorrências](./docs/funcionalidades/03-gestao-ocorrencias.md)**: Registro individual e em lote, notificação automática por e-mail a setores, sanções disciplinares, termos assinados (PDF) e exportação para o sistema acadêmico (SUAP).
4. **[Relatórios e Consultas](./docs/funcionalidades/04-relatorios.md)**: Filtros avançados e geração de relatórios analíticos.
5. **[Estudantes e Turmas](./docs/funcionalidades/05-estudantes-e-turmas.md)**: Cadastros discentes, fotos, situações de matrícula e histórico.
6. **[Cursos e Campi](./docs/funcionalidades/06-cursos-e-campi.md)**: Estrutura multicampus com isolamento de visibilidade por polo.
7. **[Usuários e Permissões](./docs/funcionalidades/07-usuarios-e-permissoes.md)**: Matriz de permissões granulares e controle de acesso.
8. **[Interface Móvel (Mobile View)](./docs/funcionalidades/08-versao-mobile.md)**: Operação ágil pelo celular ou tablet em trânsito no campus.

---

## 🛠️ Arquitetura do Projeto

* **Backend (`backend/`):** API REST em Ruby on Rails (Rails 8.1 / Ruby 4.0), PostgreSQL, autenticação via Devise + JWT, CanCanCan e CarrierWave.
* **Frontend (`sigoe-ui/`):** Aplicação Single Page Application (SPA) em Vue 3 + Vite + TailwindCSS, empacotada e executada com Bun.
* **Testes Automatizados:**
  * Backend: RSpec com 260 testes automatizados.
  * Frontend: Vitest com 280 testes automatizados (unitários, componentes e aceitação).
