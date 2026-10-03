# Autorização, privacidade e validação

A branch aplica as mesmas fronteiras às rotas Rails antigas e à API:

- Superadministradores podem acessar todos os campi e ocorrências privadas.
- Administradores locais gerenciam seu campus, mas só veem ocorrências públicas ou privadas de sua autoria.
- A leitura restrita limita usuários comuns às próprias ocorrências, inclusive URLs diretas, relatórios e gráficos.
- Permissão de editar usuários não permite promover contas, editar administradores ou alterar seu campus.
- Vínculos de curso, turma, estudante, assistente e setor são conferidos no servidor.
- Tokens JWT usam os identificadores de sessão esperados pelo Devise e são revogados no logout. Contas desativadas não podem autenticar. Após a atualização, solicite novo login aos usuários.
- PDFs exigem autorização na ocorrência e não são mais servidos pela pasta pública.

## Implantação dos PDFs existentes

Antes de reabrir o serviço após a atualização:

1. Faça backup dos anexos e pare o servidor web.
2. Execute `RAILS_ENV=production bundle exec rake attachments:privatize` em `backend/`.
3. Confirme que `public/uploads/incident_attachment` não contém mais PDFs. Arquivos órfãos, sem registro no banco, devem ser removidos dessa pasta pública e preservados no backup privado.
4. Persista `backend/storage/production/private` em volume permanente e inclua-o nos backups.
5. Reinicie o backend e publique o frontend correspondente. Links antigos de `/uploads/` deixam de funcionar; o frontend usa download autenticado.

A tarefa é repetível e interrompe se houver conflito de destino, evitando sobrescrever arquivos. Nenhum arquivo de produção é movido pela execução dos testes.

## Testes e CI

O workflow `CI` executa em pull requests e pushes na `main`, com permissão apenas de leitura. Não grava commits. Usa Ruby 3.4.10, PostgreSQL 16 e Node 20, instala dependências pelos lockfiles, executa RSpec, Vitest com cobertura e build Vue. As chaves de teste são explícitas e não dependem das credenciais de produção.

No backend, copie `config/database.yml.example` para `config/database.yml`, configure `DATABASE_URL` para um banco exclusivo de teste, `RAILS_ENV=test` e `JWT_SECRET_KEY` para uma chave descartável. Execute `npm ci`, `bundle install`, `bundle exec rails db:prepare` e `bundle exec rspec`.

No frontend, execute `npm ci`, `npm run test:coverage` e `npm run build`. O `package-lock.json` é o lockfile utilizado pela CI. Os testes em `tests/e2e` são testes de navegação em memória, não uma execução ponta a ponta em navegador com backend real.

Recomenda-se configurar os checks `backend` e `frontend` como obrigatórios na proteção da branch no GitHub. O workflow por si só não ativa essa proteção.

## Manutenção e desempenho

Listagens de ocorrências pré-carregam suas associações para evitar consultas por registro. O tamanho de página aceita `amount` e o parâmetro legado `return`, limitado a 100. Telas Vue são carregadas sob demanda. A formatação de datas sem horário preserva o dia independentemente do fuso. O envio de e-mail usa Active Job; em produção, um adaptador de fila persistente ainda deve ser configurado para garantir entrega após reinícios.

A atualização de Vitest/cobertura e jsPDF elimina os alertas encontrados no frontend durante esta revisão. O conjunto JavaScript legado do backend ainda possui alertas de dependências transitivas; a migração de Webpacker e de suas dependências requer trabalho separado, sem atualizações forçadas incompatíveis.
