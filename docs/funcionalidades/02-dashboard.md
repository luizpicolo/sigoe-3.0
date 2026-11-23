# 02 - Dashboard e Indicadores Gerenciais

## 1. Visão Geral
O **Dashboard** é a página principal exibida logo após a autenticação bem-sucedida (`/home` no Desktop e `/mobile/dashboard` no Mobile). Ele processa e apresenta gráficos estatísticos dinâmicos sobre as ocorrências escolares registradas no campus do usuário (ou em todos os campi, no caso de superadministradores).

---

## 2. Gráficos e Indicadores Disponíveis

### 1. Ocorrências por Ano
* **Tipo:** Gráfico de Linha / Barra temporal.
* **Objetivo:** Permite identificar a tendência histórica de ocorrências ao longo dos anos letivos, avaliando o impacto de projetos pedagógicos de convivência escolar e redução de conflitos.

### 2. Ocorrências por Campus (Polo)
* **Tipo:** Gráfico de Barras horizontais ou verticais.
* **Objetivo:** Comparativo entre os diferentes campi do IFMS (visível especialmente para a gestão sistêmica e reitoria/PROEN).

### 3. Ocorrências por Curso
* **Tipo:** Gráfico de Barras por curso.
* **Objetivo:** Destaca quais cursos apresentam maior número de ocorrências, permitindo que coordenações de curso e equipes pedagógicas realizem intervenções direcionadas.

### 4. Tipos de Ocorrência
* **Tipo:** Gráfico de Barras / Distribuição por categoria.
* **Objetivo:** Demonstra a recorrência das infrações (por exemplo: atrasos, ausência de uniforme, brigas/agressões verbais, uso indevido de celular em aula, danos ao patrimônio público).

### 5. Sanções Aplicadas
* **Tipo:** Gráfico de Pizza / Rosca.
* **Categorias:**
  * **Advertência Verbal**
  * **Advertência Escrita**
  * **Suspensão**
  * **Desligamento**
  * **Não se Aplica** (ocorrências de mediação ou informativas)

### 6. Situação de Resolução (Status)
* **Tipo:** Gráfico de Distribuição.
* **Categorias:**
  * **Apenas Registradas (Pendentes):** Ocorrências que ainda aguardam atendimento, ciência ou aplicação de medidas.
  * **Dada Ciência / Resolvidas:** Ocorrências que já foram concluídas e arquivadas.

---

## 3. Escopo de Visibilidade dos Dados
Os dados calculados pelo Dashboard respeitam rigorosamente a segurança por campus:
* Servidores lotados em um determinado campus visualizam apenas os registros do seu respectivo polo.
* Superadministradores têm visão panorâmica e integrada de todas as unidades da instituição.
