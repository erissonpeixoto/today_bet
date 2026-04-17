# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Stack

Rails 8.1 · PostgreSQL · Tailwind CSS (via `tailwindcss-rails`) · Importmap · Turbo/Stimulus · Devise · Pagy

## Development Setup

PostgreSQL runs in Docker (porta 5433 exposta ao host). O `.env` na raiz aponta para ele:

```
DATABASE_URL=postgresql://bet_user:bet_password@localhost:5433/today_bet_development
```

```bash
docker compose up -d db   # sempre antes de iniciar o app
bin/rails server
# ou
bin/dev
```

Dentro do container (para operações de banco):
```bash
docker compose exec web bundle exec rails db:migrate db:seed
```

## Common Commands

```bash
bin/rails server                        # inicia o app
bin/rails db:migrate                    # roda migrations
bin/rails db:seed                       # popula dados de exemplo
bin/rails routes                        # lista rotas
bundle exec rubocop                     # linting
bundle exec brakeman                    # análise de segurança
```

## Architecture

### Domain Models

- **User** — Devise auth. Campo `admin` booleano. `display_name` retorna `@username`.
- **FootballClub** — Times com `name` (unique) e `logo_url` (URL externa, CDN api-sports.io no formato `https://media.api-sports.io/football/teams/{id}.png`).
- **Match** — Partida entre dois `FootballClub` (`home_club`, `away_club`). `home_team`/`away_team` são métodos delegados ao clube. Status enum: `scheduled`, `live`, `finished`.
- **Tip** — Palpite de um `User` em um `Match`. Um usuário só pode ter um palpite por mercado por partida. Counters desnormalizados: `votes_agree_count`, `votes_disagree_count`, `votes_hot_count`, `comments_count`.
- **Vote** — Toggle: criar o mesmo voto duas vezes destrói o primeiro. Atualiza counters via callbacks `after_create`/`after_destroy`.
- **Comment** — Comentário em um Tip.

### Tip Markets (enum inteiros — não reordenar sem migration)

`vitoria_mandante(0)`, `vitoria_visitante(1)`, `empate(2)`, `ambos_marcam(3)`, `over_1_5(4)`, `under_1_5(5)`, `over_2_5(6)`, `under_2_5(7)`, `mais_escanteios_mandante(8)`, `mais_escanteios_visitante(9)`, `menos_escanteios_mandante(10)`, `menos_escanteios_visitante(11)`.

### Layouts e Rotas

Dois layouts: `application` (site público) e `admin` (painel).

```
/                          matches#index   (jogos do dia, paginado com Pagy)
/matches/:id               matches#show    (palpites ordenados por 🔥)
/matches/:id/tips          tips#create
/matches/:id/tips/:id/votes votes#create  (toggle, responde Turbo Stream)
/admin/*                   Admin namespace, requer admin?
/admin/football_clubs      CRUD de times
/admin/matches             CRUD de partidas
```

### Padrões importantes

- **Vote toggle**: `VotesController#create` destrói o voto se já existe, cria se não existe. Responde via `turbo_stream` atualizando `#tip_votes_{id}`.
- **Counters desnormalizados**: nunca leia `tip.votes.count` em loop — use `tip.votes_agree_count` etc.
- **Logo fallback**: todas as `<img>` de logo têm `onerror="this.style.display='none'"`.
- **Admin guard**: `Admin::BaseController` exige `authenticate_user!` + `require_admin!`.

### Design System (público)

Fundo escuro `#0f1923`, cards `#1a2535`, bordas `#243040`, verde primário `#00c853`, amarelo admin/destaque `#f5c518`. Botões: "Criar Conta" = verde sólido, "Entrar" = outline neutro.
