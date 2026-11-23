# 05 - Gestão de Estudantes e Turmas

## 1. Gestão de Estudantes

Acesse pelo menu lateral em **Administrador > Estudantes** (`/administrador/estudantes/listar`).

### 1.1 Listagem e Busca
* Permite localizar discentes pelo nome, número de R.A. (Registro Acadêmico), curso ou turma.
* A listagem exibe a foto do estudante, nome, matrícula, curso e ações disponíveis.

### 1.2 Cadastro e Edição de Estudantes
Ao cadastrar ou editar um estudante (`/administrador/estudantes/novo` ou `/editar/:id`), informe:
* **Nome Completo**
* **R.A. (Registro Acadêmico)**
* **Curso** e **Turma** aos quais o estudante está vinculado
* **Situação da Matrícula:**
  * *Em curso* (alunos regulares ativos)
  * *Egresso*, *Concluído*, *Trancado*, *Evadido*, *Desligado*, *Transferido*, etc.
* **Foto do Estudante:** Importante para identificação visual ágil pelos assistentes de alunos nos corredores e portarias.
* **Dados de Contato:** Telefone do aluno, nome do responsável e telefone de contato do responsável.
* **Documentos:** CPF, data de nascimento e matrícula.

### 1.3 Ficha do Estudante (Visualização)
Na tela de detalhes do estudante (`/administrador/estudantes/visualizar/:id`):
* Visualize o perfil completo do discente.
* Acesse o **histórico integral de ocorrências** vinculadas ao aluno ao longo de toda a sua trajetória acadêmica na instituição.

---

## 2. Gestão de Turmas (School Groups)

Acesse pelo menu lateral em **Administrador > Turmas** (`/administrador/turmas/listar`).

### 2.1 Finalidade
As turmas organizam os alunos em agrupamentos pedagógicos (ex.: "1º Ano A - Informática 2026", "2º Módulo - Alimentos").

### 2.2 Cadastro e Edição de Turmas
No formulário de turma (`/administrador/turmas/novo` ou `/editar/:id`):
* **Nome da Turma:** Identificador da classe.
* **Curso:** Curso ao qual a turma pertence.
* Facilita a localização em lote e a emissão de relatórios específicos para conselhos de classe.
