# SIGOE Backend

O backend do SIGOE é uma API em Ruby on Rails responsável pela lógica de negócio, autenticação, autorização, persistência de dados e geração de relatórios.

## Stack

- Ruby 3.4.10
- Ruby on Rails 7
- PostgreSQL
- Devise / JWT

## Configuração

Instale as dependências:

```bash
bundle install
```

Configure o banco de dados:

```bash
cp config/database.yml.example config/database.yml
bundle exec rails db:setup
```

Inicie a API:

```bash
bundle exec rails server
```

## Testes

```bash
bundle exec rspec
```

O frontend do projeto está em `../sigoe-ui` e é executado separadamente.
