# Bet do Dia

App de apostas sociais onde usuários postam palpites em jogos de futebol do dia, reagem aos palpites dos outros e sobem no ranking.

## Stack

- **Ruby on Rails 8.1** com Hotwire (Turbo + Stimulus)
- **PostgreSQL 16** via Docker
- **Tailwind CSS** via `tailwindcss-rails` (sem Node)
- **Devise** para autenticação
- **Pagy** para paginação
- **Importmap** para JavaScript

## Pré-requisitos

- Ruby 3.4.5 (recomendado via [asdf](https://asdf-vm.com))
- Docker e Docker Compose

## Como executar

**1. Suba o banco de dados:**

```bash
docker compose up -d db
```

**2. Instale as dependências:**

```bash
bundle install
```

**3. Configure o banco e popule os dados de exemplo:**

```bash
bin/rails db:create db:migrate db:seed
```

**4. Inicie o servidor:**

```bash
bin/dev
```

Acesse em [http://localhost:3000](http://localhost:3000)

> `bin/dev` inicia o Rails server e o watcher do Tailwind em paralelo. Alternativamente use `bin/rails server` (sem rebuild automático do CSS).

## Usuários de exemplo (seeds)

| E-mail | Senha | Admin |
|---|---|---|
| admin@betdodia.com | password123 | ✅ |
| joao@example.com | password123 | ❌ |

## Comandos úteis

```bash
bin/rails db:migrate          # rodar migrations
bin/rails db:seed             # recarregar seeds
bin/rails tailwindcss:build   # recompilar CSS manualmente
bin/rails routes              # listar rotas
bundle exec rubocop           # linting
bundle exec brakeman          # análise de segurança
```

## Arquitetura resumida

- **User** — Devise + campo `username` + `admin` booleano
- **FootballClub** — Times com nome e logo (CDN api-sports.io)
- **Match** — Partida entre dois clubes; status `scheduled / live / finished`
- **Tip** — Palpite de um usuário em um mercado de uma partida (ex: Over 2.5, Ambos Marcam)
- **Vote** — Reação ao palpite: 👍 concordo / 👎 discordo / 🔥 quente (toggle via Turbo Stream)
- **Comment** — Comentário em um palpite

O painel admin (`/admin`) é restrito a usuários com `admin: true` e permite gerenciar times e partidas.
