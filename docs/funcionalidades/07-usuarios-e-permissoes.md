# 07 - Gestão de Usuários e Matriz de Permissões

## 1. Visão Geral
O SIGOE implementa uma política de controle de acesso rigorosa e granular. Servidores e colaboradores têm acessos estritamente adequados às suas funções regimentais (assistentes de alunos, professores, comissão disciplinar, coordenadores ou administradores).

---

## 2. Cadastro de Usuários
Acesse pelo menu lateral em **Administrador > Usuários** (`/administrador/usuarios/listar`).

### Campos do Formulário (`/novo` e `/editar/:id`):
* **Nome Completo**
* **Nome de Usuário (Login)**: Único em todo o sistema.
* **E-mail Institucional**: Utilizado para comunicações e redefinição de acesso.
* **Matrícula SIAPE**: Identificador funcional do servidor.
* **Polo (Campus)**: Define o campus de atuação e visibilidade padrão.
* **Foto / Avatar**: Imagem de perfil do servidor.
* **Senha e Confirmação de Senha**: Definidas no cadastro inicial.
* **Administrador (`admin`)**: Define se o usuário tem privilégios de gestão administrativa.
* **Status Ativo (`status`)**: Permite habilitar ou suspender o acesso do usuário ao sistema sem excluir seu histórico.

---

## 3. Matriz de Permissões Granulares

Ao visualizar um usuário (`/administrador/usuarios/visualizar/:id`), clique na aba ou botão **Permissões** (`/permissoes`).

A matriz permite configurar ações específicas para cada entidade do sistema:

### Entidades do Sistema
1. **Usuários (`users`)**
2. **Estudantes (`students`)**
3. **Cursos (`courses`)**
4. **Turmas (`classes`)**
5. **Ocorrências (`occurrences`)**

### Ações Configuráveis
| Permissão | Descrição |
| :--- | :--- |
| `can_create` | Permite cadastrar novos registros daquela entidade. |
| `can_read` | Permite consultar registros públicos do campus daquela entidade. |
| `can_read_restricted` | Permite ao usuário visualizar **apenas as ocorrências cadastradas por ele próprio**. |
| `can_update` | Permite editar registros existentes. |
| `can_destroy` | Permite excluir registros do sistema. |
| `can_sanction` | Permite definir sanções disciplinares, deveres descumpridos e soluções em ocorrências. |
| `can_attach_pdf` | Permite anexar documentos e termos de ocorrência digitalizados em PDF. |
| `can_export_to_academic_system` | Permite acionar o fluxo de exportação do atendimento para o sistema acadêmico (SUAP). |
| `can_extras` | Permite ações adicionais legadas de confirmação e assinatura. |

> **Observação:** Administradores (`admin` ou `super_admin`) possuem permissão de gerenciamento total (`can :manage, :all`) sobre os recursos de seu campus.
