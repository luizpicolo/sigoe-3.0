# Tutorial de Uso do SIGOE (Sistema Integrado de Gestão de Ocorrências Escolares)

Bem-vindo ao **Tutorial Oficial de Uso do SIGOE**. Este documento foi elaborado para guiar usuários, assistentes de alunos, professores, coordenadores pedagógicos e administradores na utilização prática de todas as ferramentas e fluxos do sistema.

---

## Sumário
1. [Visão Geral do Sistema](#1-visão-geral-do-sistema)
2. [Acesso ao Sistema e Primeiro Login](#2-acesso-ao-sistema-e-primeiro-login)
3. [Navegação e Interface (Desktop e Mobile)](#3-navegação-e-interface-desktop-e-mobile)
4. [Painel Inicial (Dashboard)](#4-painel-inicial-dashboard)
5. [Gestão de Ocorrências Escolares](#5-gestão-de-ocorrências-escolares)
   - [5.1 Registrar Nova Ocorrência](#51-registrar-nova-ocorrência)
   - [5.2 Registro para Múltiplos Estudantes](#52-registro-para-múltiplos-estudantes)
   - [5.3 Tipos de Acesso: Público vs. Privado](#53-tipos-de-acesso-público-vs-privado)
   - [5.4 Notificação Automática por E-mail ao Setor](#54-notificação-automática-por-e-mail-ao-setor)
   - [5.5 Visualizar e Acompanhar Detalhes da Ocorrência](#55-visualizar-e-acompanhar-detalhes-da-ocorrência)
   - [5.6 Aplicação de Sanções Disciplinares e Solução](#56-aplicação-de-sanções-disciplinares-e-solução)
   - [5.7 Impressão do Termo de Ocorrência](#57-impressão-do-termo-de-ocorrência)
   - [5.8 Anexar Documentos e PDFs Assinados](#58-anexar-documentos-e-pdfs-assinados)
   - [5.9 Exportação para o Sistema Acadêmico (SUAP/Acadêmico)](#59-exportação-para-o-sistema-acadêmico-suapacadêmico)
6. [Emissão de Relatórios Analíticos](#6-emissão-de-relatórios-analíticos)
7. [Gestão Acadêmica](#7-gestão-acadêmica)
   - [7.1 Estudantes](#71-estudantes)
   - [7.2 Turmas](#72-turmas)
   - [7.3 Cursos](#73-cursos)
8. [Administração de Usuários e Permissões](#8-administração-de-usuários-e-permissões)
   - [8.1 Cadastro e Edição de Usuários](#81-cadastro-e-edição-de-usuários)
   - [8.2 Matriz de Permissões Granulares](#82-matriz-de-permissões-granulares)
   - [8.3 Alteração de Senha](#83-alteração-de-senha)
9. [Uso no Dispositivo Móvel (Mobile)](#9-uso-no-dispositivo-móvel-mobile)
10. [Dúvidas Frequentes e Boas Práticas](#10-dúvidas-frequentes-e-boas-práticas)

---

## 1. Visão Geral do Sistema

O **SIGOE** é uma plataforma institucional voltada ao registro, triagem, acompanhamento e resolução de ocorrências disciplinares e pedagógicas nos campi do Instituto Federal de Mato Grosso do Sul (IFMS).

### Principais Objetivos
* Centralizar o histórico disciplinar e de atendimento aos estudantes.
* Assegurar conformidade com o Regulamento Disciplinar Discente da instituição.
* Garantir visibilidade adequada e sigilo de informações sensíveis por meio de controle de permissões por perfil e campus.
* Facilitar a comunicação imediata com setores pedagógicos, assistenciais e responsáveis.

---

## 2. Acesso ao Sistema e Primeiro Login

### Tela de Autenticação
1. Acesse o endereço do sistema fornecido pela sua instituição no navegador de sua preferência.
2. Na tela de login, informe seu **Nome de Usuário** ou **E-mail** cadastrado e sua **Senha**.
3. Clique em **Entrar**.

> **Dica de Segurança:** Caso esteja no seu primeiro acesso com senha provisória, dirija-se imediatamente à opção de alteração de senha após o login.

---

## 3. Navegação e Interface (Desktop e Mobile)

### Barra Superior (Header)
* **Logotipo SIGOE:** Permite voltar rapidamente à tela principal.
* **Perfil do Usuário:** Exibe seu nome, foto e permite acessar **Trocar Senha** ou efetuar **Logout (Sair)**.

### Barra Lateral (Sidebar - Desktop)
* **Início:** Dashboard e visão estatística geral.
* **Ocorrências:**
  * *Listar Ocorrências:* Busca, filtros e listagem completa.
  * *Nova Ocorrência:* Formulário de registro.
  * *Relatório:* Gerador de relatórios analíticos por período e filtros.
* **Administrador:**
  * *Estudantes:* Base de alunos, situações cadastrais e históricos.
  * *Turmas:* Turmas ativas e anos letivos.
  * *Cursos:* Cursos técnicos integrados, subsequentes e superiores.
  * *Usuários:* Gestão de contas e permissões (visível para perfis autorizados).

---

## 4. Painel Inicial (Dashboard)

Ao fazer login, o usuário é direcionado ao **Dashboard**, que consolida indicadores em tempo real das ocorrências do seu campus (ou de todos os campi, no caso de administradores gerais):

1. **Ocorrências por Ano:** Gráfico histórico de evolução dos registros ao longo dos anos.
2. **Ocorrências por Campus:** Distribuição geográfica entre os polos do IFMS.
3. **Ocorrências por Curso:** Cursos com maior incidência de registros para apoiar ações pedagógicas preventivas.
4. **Tipos de Ocorrência:** Frequência de cada tipo (atraso, indisciplina, uso indevido de equipamentos, uniforme, etc.).
5. **Sanções Aplicadas:** Totalizadores de advertências verbais, advertências escritas, suspensões e desligamentos.
6. **Status de Resolução:** Proporção de ocorrências resolvidas vs. pendentes.

---

## 5. Gestão de Ocorrências Escolares

O módulo de ocorrências é o núcleo operacional do SIGOE.

### 5.1 Registrar Nova Ocorrência
1. No menu lateral, acesse **Ocorrências > Nova Ocorrência** (ou clique no botão **+ Nova Ocorrência** na listagem).
2. Preencha os campos essenciais:
   * **Tipo de Aluno:** *Não residente* ou *Residente* (para campi com regime de internato/residência estudantil).
   * **Assistente Responsável:** Servidor que acompanhou ou realizou o atendimento inicial.
   * **Tipo de Ocorrência:** Selecione a categoria da ocorrência (ex.: Descumprimento de regras, Atraso, Conflito, etc.).
   * **Data e Horário:** Data do fato e hora aproximada do ocorrido.
   * **Visibilidade:** *Pública* (visível para servidores com permissão de leitura no campus) ou *Privada* (visível apenas para o autor do registro e administradores).
   * **Encaminhar ao Setor:** Caso a ocorrência demande ação de um setor específico (ex.: Coordenação Pedagógica, NAPNE, Serviço Social, Chefia de Ensino), selecione o setor desejado. Um e-mail com os dados da ocorrência será disparado automaticamente para o e-mail cadastrado desse setor.
   * **Descrição dos Fatos:** Relate com clareza, objetividade e riqueza de detalhes os acontecimentos.

### 5.2 Registro para Múltiplos Estudantes
Um dos grandes diferenciais do SIGOE é a agilidade no atendimento de incidentes coletivos:
* No campo **Estudantes**, você pode buscar pelo nome ou R.A. e adicionar múltiplos estudantes ao mesmo registro.
* Ao salvar, o sistema cria automaticamente as ocorrências individualizadas para cada discente selecionado, preservando o histórico de cada aluno sem exigir preenchimento repetitivo.

### 5.3 Tipos de Acesso: Público vs. Privado
* **Pública:** Disponível para consulta por toda a equipe pedagógica e de assistência estudantil autorizada do campus. Recomendada para a maioria das ocorrências disciplinares comuns.
* **Privada:** Fica restrita ao usuário que realizou o registro e aos administradores do sistema. Indicada para assuntos de alta sensibilidade, vulnerabilidade social ou saúde.

### 5.4 Notificação Automática por E-mail ao Setor
Quando um setor é selecionado no campo *Encaminhar ao Setor*, o SIGOE envia uma notificação automática detalhando a ocorrência diretamente à caixa postal do setor. Isso acelera o fluxo de encaminhamentos internos sem necessidade de memorandos manuais.

### 5.5 Visualizar e Acompanhar Detalhes da Ocorrência
Na listagem de ocorrências (`/ocorrencias/ocorrencias/listar`), localize o registro desejado e clique no ícone do olho (**Visualizar**):
* O cabeçalho exibe os dados do estudante (com foto, curso, R.A. e campus).
* A seção central exibe todos os dados do registro (data, horário, autor, assistente, descrição e histórico).
* O painel lateral disponibiliza as ações permitidas de acordo com o seu perfil.

### 5.6 Aplicação de Sanções Disciplinares e Solução
Usuários com perfil de gestão disciplinar (`can_sanction`):
1. Podem editar a ocorrência e preencher os campos do **Regulamento Disciplinar**:
   * **Deveres do Estudante:** Itens descumpridos previstos no regulamento.
   * **Proibições e Responsabilidades:** Dispositivos disciplinares violados.
   * **Sanção Aplicada:** *Advertência Verbal*, *Advertência Escrita*, *Suspensão* ou *Desligamento*.
   * **Solução / Providência Adotada:** Despacho informando a decisão ou acordo firmado.
   * **Situação:** Marcar como *Resolvida* (`Sim`) ou mantê-la como pendente (`Não`).

### 5.7 Impressão do Termo de Ocorrência
Na tela de visualização da ocorrência:
1. Clique no botão **Imprimir Relatório**.
2. O sistema gera uma via padronizada contendo todos os dados, os artigos pertinentes do Regulamento Disciplinar e os campos formais para assinatura do estudante, responsável legal e servidor do IFMS.
3. É possível salvar em PDF ou imprimir diretamente para colher as assinaturas físicas.

### 5.8 Anexar Documentos e PDFs Assinados
Após colher a assinatura no termo impresso:
1. Digitalize o documento em formato **PDF**.
2. Na página de detalhes da ocorrência, acesse o painel **Anexos**.
3. Selecione o arquivo digitalizado e clique em **Enviar Anexo**.
4. O documento assinado fica arquivado de forma segura na ocorrência, disponível para download e conferência a qualquer momento por usuários autorizados.

### 5.9 Exportação para o Sistema Acadêmico (SUAP/Acadêmico)
Para integrar os atendimentos disciplinares ao prontuário acadêmico institucional:
1. Na tela de detalhes da ocorrência, clique em **Exportar para Sistema Acadêmico**.
2. Um modal será exibido com os dados formatados e o link direto para o módulo de atendimentos do sistema acadêmico do IFMS, preenchendo automaticamente a referência do R.A. e prontuário do aluno.

---

## 6. Emissão de Relatórios Analíticos

Para subsidiar reuniões de conselho de classe, relatórios de gestão e acompanhamento do NAPNE/Pedagógico:
1. Acesse o menu **Ocorrências > Relatório** (`/ocorrencias/relatorio`).
2. Defina os critérios de pesquisa:
   * **Período:** Data inicial e data final obrigatórias.
   * **Estudante:** Filtrar ocorrências de um aluno específico.
   * **Curso:** Filtrar por curso (ex.: Técnico Integrado em Informática).
   * **Turma:** Filtrar por grupo específico.
   * **Tipo de Ocorrência:** Focar em categorias específicas.
   * **Status de Resolução:** Apenas resolvidas ou apenas pendentes.
3. Clique em **Pesquisar**.
4. O sistema exibe a listagem consolidada e permite gerar a versão impressa ou exportada para documentação institucional.

---

## 7. Gestão Acadêmica

### 7.1 Estudantes
Disponível em **Administrador > Estudantes**:
* **Busca Rápida:** Filtre alunos por nome, R.A., curso ou turma.
* **Ficha do Estudante:** Visualize histórico de ocorrências acumuladas, dados de contato, responsáveis e situação de matrícula (*Em curso*, *Egresso*, *Trancado*, *Evadido*, etc.).
* **Cadastro e Edição:** Inclusão de dados discentes, foto do estudante e atribuição de turma.

### 7.2 Turmas
Disponível em **Administrador > Turmas**:
* Cadastro e vinculação de turmas escolares aos seus respectivos cursos e anos letivos.
* Essencial para a filtragem eficiente nos formulários de ocorrências e relatórios.

### 7.3 Cursos
Disponível em **Administrador > Cursos**:
* Cadastro da estrutura de cursos do campus (código, sigla, nome e polo).
* Delimita o escopo de visibilidade por campus para os servidores.

---

## 8. Administração de Usuários e Permissões

### 8.1 Cadastro e Edição de Usuários
Disponível em **Administrador > Usuários**:
* Cadastro de servidores (nome, e-mail institucional, matrícula SIAPE, login e campus/polo de lotação).
* Ativação e inativação de contas de acesso.

### 8.2 Matriz de Permissões Granulares
O SIGOE adota uma política de controle de acesso baseada no princípio do menor privilégio. Na visualização de um usuário, clique em **Permissões**:
Você pode habilitar ou desabilitar permissões independentes para cada entidade do sistema:
* **Entidades:** Usuários, Estudantes, Cursos, Turmas e Ocorrências.
* **Ações:**
  * *Criar (can_create):* Criar novos registros.
  * *Ler Geral (can_read):* Consultar todos os registros públicos do campus.
  * *Leitura Restrita (can_read_restricted):* Apenas visualizar ocorrências registradas pelo próprio usuário.
  * *Atualizar (can_update):* Editar registros existentes.
  * *Excluir (can_destroy):* Remover registros.
  * *Aplicar Sanção (can_sanction):* Apenas para gestores disciplinares.
  * *Anexar PDF (can_attach_pdf):* Fazer upload de termos e documentos comprobatórios.
  * *Exportar p/ Sistema Acadêmico (can_export_to_academic_system):* Permite disparar a exportação para o SUAP/Acadêmico.

### 8.3 Alteração de Senha
Qualquer usuário pode trocar sua própria senha clicando em seu nome de usuário no canto superior direito e selecionando **Trocar Senha**:
* Informe a senha atual, a nova senha e confirme.

---

## 9. Uso no Dispositivo Móvel (Mobile)

O SIGOE possui interface mobile nativa e dedicada, pensada para o uso rápido por assistentes de alunos e servidores em trânsito no campus:
* Ao acessar o sistema em smartphones e tablets, a interface mobile é ativada automaticamente.
* O menu inferior e os botões facilitam o registro imediato de ocorrências no próprio pátio, corredores ou laboratórios.
* Permite consulta rápida por foto e R.A. de estudantes e registro fotográfico ou de termos.

---

## 10. Dúvidas Frequentes e Boas Práticas

### Posso registrar uma ocorrência sem aplicar sanção imediata?
**Sim.** Grande parte das ocorrências iniciais são informativas ou de mediação de conflito. A definição de sanção pode ser adicionada posteriormente pelo servidor ou comissão disciplinar competente.

### O que acontece quando marco uma ocorrência como Privada?
Ela não aparecerá na listagem geral para outros usuários do campus; apenas o servidor que a criou e os administradores do sistema terão acesso para consultá-la.

### Como cancelar ou retificar um registro?
Se você tiver permissão de edição (`can_update`), abra os detalhes da ocorrência e clique em **Editar Ocorrência**. Caso precise excluí-la, utilize o botão **Excluir** (sujeito à permissão `can_destroy`).
