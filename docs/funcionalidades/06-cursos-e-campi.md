# 06 - Cursos e Estrutura de Campi (Polos)

## 1. Visão Geral
O SIGOE é um sistema **multicampus**, projetado para atender todos os polos e campi do Instituto Federal de Mato Grosso do Sul (IFMS). A estrutura de cursos e polos garante a separação lógica e a segurança dos dados entre as diferentes unidades da instituição.

---

## 2. Gestão de Cursos

Acesse pelo menu lateral em **Administrador > Cursos** (`/administrador/cursos/listar`).

### 2.1 Cadastro de Cursos
No formulário de cursos (`/administrador/cursos/novo` ou `/editar/:id`), informe:
* **Nome do Curso:** Nome completo (ex.: *Técnico Integrado em Informática*, *Bacharelado em Agronomia*).
* **Sigla / Inicial:** Código reduzido do curso (ex.: *TII*, *AGR*).
* **Campus (Polo):** Campus ao qual o curso está vinculado (ex.: *Campus Aquidauana*, *Campus Campo Grande*, *Campus Corumbá*, etc.).

---

## 3. Isolamento e Escopo por Polo
* Cada usuário do sistema está associado a um determinado Polo (Campus).
* As consultas a estudantes, ocorrências, turmas e cursos filtram automaticamente os registros referentes ao polo de lotação do servidor logado.
* Usuários com perfil `super_admin` têm visão global, podendo navegar e auditar dados de qualquer um dos campi da instituição.
