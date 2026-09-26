# SIGOE

SIGOE é um sistema para gestão de ocorrências escolares, desenvolvido para apoiar a administração e o acompanhamento de registros acadêmicos e disciplinares em no Instituto Federal de Mato Grosso do Sul. O software foi desenvolvido a partir de um Trabalho de Conclusão de Curso e hoje está sendo usando em grande parte dos Campi da instituição.

O projeto está organizado em duas partes principais:

- [backend](./backend): aplicação em Ruby on Rails, responsável pela lógica de negócio, autenticação, regras de acesso e persistência de dados.
- [sigoe-ui](./sigoe-ui): frontend em Vue.js, responsável pela interface web e experiência do usuário.

## Visão geral

O sistema permite:

- cadastro e gestão de usuários, alunos e cursos;
- registro de ocorrências escolares;
- organização por institutos, polos, grupos escolares e setores;
- controle de permissões e acesso por perfil;
- geração de relatórios e painel administrativo;
- consulta e acompanhamento de dados por meio de interfaces web.

## Stack tecnológica

- Ruby 3.4.10
- Ruby on Rails 7
- PostgreSQL
- Vue.js 3
- Vite
- Devise / JWT

## Estrutura do repositório

```text
.
├── backend/        # aplicação Rails
├── sigoe-ui/       # frontend em Vue.js
└── README.md       # documentação do projeto
```

## Pré-requisitos

Antes de iniciar, certifique-se de ter instalado:

- Ruby 3.4.10
- Bundler
- Node.js 20+
- npm
- PostgreSQL

## Configuração do backend

Acesse a pasta do backend e instale as dependências:

```bash
cd backend
bundle install
```

Configure o banco de dados e prepare o ambiente:

```bash
cp config/database.yml.example config/database.yml
bundle exec rails db:setup
```

Se o projeto exigir arquivos de ambiente adicionais, ajuste os arquivos de configuração conforme o ambiente local antes de iniciar a aplicação.

Inicie o servidor Rails:

```bash
bundle exec rails server
```

A aplicação estará disponível em:

```text
http://localhost:3000
```

## Configuração do frontend

Instale as dependências do frontend:

```bash
cd sigoe-ui
npm install
```

Inicie o ambiente de desenvolvimento:

```bash
npm run dev
```

O frontend normalmente fica disponível em:

```text
http://localhost:5173
```

## Testes

### Backend

```bash
cd backend
bundle exec rspec
```

### Frontend

```bash
cd sigoe-ui
npm run test
```

## Execução com Docker

Também é possível subir o backend com Docker Compose na pasta [backend](./backend):

```bash
cd backend
docker-compose up
```

## Documentação adicional

Para detalhes específicos de cada parte do sistema, consulte os READMEs internos:

- [backend/README.md](./backend/README.md)
- [sigoe-ui/README.md](./sigoe-ui/README.md)

## Licença

Este projeto utiliza a licença MIT.
