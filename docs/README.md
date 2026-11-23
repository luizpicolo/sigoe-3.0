# Documentação do Projeto SIGOE

O **SIGOE** (Sistema Integrado de Gestão de Ocorrências Escolares) é uma solução desenvolvida para apoiar a administração, a disciplina pedagógica e o acompanhamento de registros discentes no Instituto Federal de Mato Grosso do Sul (IFMS).

---

## 📚 Guias Disponíveis

Nesta pasta de documentação, você encontra materiais completos tanto para o usuário final quanto para administradores e equipe técnica:

### 📖 Para o Usuário Final
* **[Tutorial Completo do Usuário (Passo a Passo)](./tutorial-usuario.md):** Manual completo de utilização de todas as telas, formulários e operações diárias do sistema.

### 🔍 Manuais Detalhados por Funcionalidade
1. **[Autenticação, Sessão e Perfil](./funcionalidades/01-autenticacao-e-perfil.md)**: Login via JWT, controle de sessão, troca de senhas e segurança.
2. **[Dashboard e Métricas Gerenciais](./funcionalidades/02-dashboard.md)**: Explicação de todos os gráficos e indicadores em tempo real.
3. **[Gestão Completa de Ocorrências](./funcionalidades/03-gestao-ocorrencias.md)**: Ciclo de vida da ocorrência, registros individuais e múltiplos, notificações por e-mail a setores, aplicação de sanções, upload de PDFs assinados e exportação acadêmica (SUAP/Acadêmico).
4. **[Relatórios e Consultas Avançadas](./funcionalidades/04-relatorios.md)**: Emissão de relatórios customizados com múltiplos filtros.
5. **[Estudantes e Turmas](./funcionalidades/05-estudantes-e-turmas.md)**: Gestão de discentes, fotografias, R.A. e organização por turmas.
6. **[Cursos e Campi (Polos)](./funcionalidades/06-cursos-e-campi.md)**: Estrutura organizacional multicampus e isolamento de dados por polo.
7. **[Usuários e Matriz de Permissões](./funcionalidades/07-usuarios-e-permissoes.md)**: Administração de acessos granulares, permissões restritas e perfis de administradores.
8. **[Interface Móvel (Mobile View)](./funcionalidades/08-versao-mobile.md)**: Guia de operação rápida pelo celular para assistentes de alunos e servidores em trânsito.

### 🚀 Para Desenvolvedores e Administradores de Infraestrutura
* **[Guia de Deploy e Publicação](./deploy.md)**: Comandos para deploy no Dokku/Docker e criação de releases.

---

## 🏛️ Contexto e Regulamentação
O sistema atende diretamente aos preceitos do **Regulamento Disciplinar Discente do IFMS**, permitindo:
- Registro formal de atos infracionais e atitudes exemplares.
- Triagem pedagógica antes da instauração de processos disciplinares.
- Garantia de ampla defesa, registro de ciência e colheita de assinaturas formais.
- Rastreabilidade de atendimentos em conformidade com as diretrizes da Pró-Reitoria de Ensino (PROEN).
