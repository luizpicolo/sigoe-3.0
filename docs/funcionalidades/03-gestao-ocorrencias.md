# 03 - Gestão Completa de Ocorrências Escolares

## 1. Visão Geral
O módulo de **Ocorrências** é o núcleo do SIGOE. Ele abrange desde a constatação inicial do fato por um assistente de alunos ou professor até a conclusão das medidas pedagógicas e disciplinares, incluindo notificações automáticas, upload de termos assinados e sincronização com o sistema acadêmico institucional.

---

## 2. Formulário de Registro de Ocorrência

O formulário pode ser acessado em **Ocorrências > Nova Ocorrência** (`/ocorrencias/ocorrencias/novo`).

### 2.1 Seleção de Estudantes (Individual ou Múltipla)
* O campo **Estudantes** conta com busca dinâmica inteligente: basta digitar o nome do aluno ou o seu R.A. (Registro Acadêmico).
* É possível selecionar **um ou vários estudantes** no mesmo ato de registro. Caso haja múltiplos estudantes envolvidos em um mesmo episódio, o SIGOE gerará automaticamente registros individuais vinculados a cada um deles.

### 2.2 Dados Principais
* **Tipo de Aluno:**
  * *Não residente:* Estudante comum que frequenta as aulas e retorna à sua residência.
  * *Residente:* Estudante que usufrui da moradia estudantil/alojamento institucional.
* **Assistente Responsável:** Servidor (assistente de alunos, docente ou técnico) que realizou o atendimento ou acolhimento inicial.
* **Tipo de Ocorrência:** Classificação da conduta segundo as tipificações do IFMS.
* **Data e Horário:** Registro temporal exato de quando o evento aconteceu.
* **Visibilidade:**
  * *Pública:* Ocorrência visível para servidores com permissão de leitura no campus.
  * *Privada:* Ocorrência restrita ao servidor que a criou e aos administradores.
* **Encaminhar ao Setor:** Seleção opcional de um setor institucional (ex.: NAPNE, Coordenação Pedagógica, Direção de Ensino). Ao salvar, um e-mail com resumo e dados do fato é transmitido ao setor.
* **Descrição:** Relato claro, factual e objetivo sobre o que aconteceu.

---

## 3. Regulamento Disciplinar Discente e Sanções

Para usuários autorizados com o papel de aplicação de sanções (`can_sanction`):

### 3.1 Deveres e Proibições
O formulário permite assinalar os dispositivos previstos no Regulamento Disciplinar Discente:
* **Deveres do Estudante:** Lista de obrigações institucionais que deixaram de ser cumpridas.
* **Proibições e Responsabilidades:** Artigos e incisos violados pelo discente.

### 3.2 Sanções Previstas
* **Advertência Verbal:** Primeira chamada de atenção formal com caráter educativo.
* **Advertência Escrita:** Notificação formal com registro em prontuário.
* **Suspensão:** Afastamento temporário das atividades acadêmicas por período determinado.
* **Desligamento:** Sanção máxima após processo disciplinar formal.

### 3.3 Solução e Resolução
* **Solução:** Espaço para registro da decisão pedagógica, compromissos acordados e orientações repassadas aos pais ou responsáveis.
* **Ocorrência Resolvida:** Define se o caso foi solucionado (`Sim`) ou se ainda exige acompanhamento (`Não`).

---

## 4. Visualização e Detalhes da Ocorrência

Ao abrir a visualização (`/ocorrencias/ocorrencias/visualizar/:id`), o usuário visualiza:
* **Ficha do Estudante:** Nome completo, foto, curso, R.A. e campus.
* **Quadro de Informações:** Data, horário, tipo, assistente, setor notificado e autor do registro.
* **Relato e Encaminhamentos:** Descrição detalhada dos fatos e histórico.
* **Status Disciplinar:** Sanção, resolução e verificação.

---

## 5. Ações Especiais

### 5.1 Imprimir Termo de Ocorrência
O botão **Imprimir Relatório** gera na tela um documento formal com o timbre do campus, artigos infringidos do Regulamento Disciplinar e campos para assinaturas:
* Assinatura do Estudante;
* Assinatura do Responsável Legal;
* Assinatura do Servidor/Assistente de Alunos.

### 5.2 Upload de Anexos e Termos Assinados (PDF)
Após a coleta das assinaturas físicas ou apresentação de atestados e declarações:
1. Acesse o card de **Anexos** na página da ocorrência.
2. Selecione o arquivo em formato **PDF**.
3. Clique em **Enviar Anexo**.
4. O documento é armazenado e pode ser visualizado ou baixado a qualquer momento por servidores autorizados.

### 5.3 Exportação para o Sistema Acadêmico (SUAP/Acadêmico IFMS)
Para integrar os registros disciplinares com o sistema oficial de registro escolar:
1. Clique em **Exportar para Sistema Acadêmico**.
2. O sistema formata os parâmetros e abre a tela de atendimento do sistema acadêmico do IFMS vinculada ao R.A. e prontuário do aluno, evitando duplicidade de digitação manual.
