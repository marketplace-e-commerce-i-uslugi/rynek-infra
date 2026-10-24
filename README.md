# rynek-infra

Infrastruktura platformy **Rynek**.

> Status: **w budowie**. `local/docker-compose.yml` zawiera Redis (limity w api-gateway) i PostgreSQL.

```bash
docker compose -f local/docker-compose.yml up -d
```

## PostgreSQL

Lokalnie jeden kontener, ale każdy serwis ma własną bazę i konto (`local/postgres/init/01-databases.sql`):

| Serwis | Baza | Użytkownik / hasło |
|---|---|---|
| identity-service | `identity` | `identity` / `identity` |

Skrypt z `postgres/init` wykonuje się tylko przy pierwszym starcie pustego wolumenu. Po dopisaniu nowej bazy wykonaj jej blok ręcznie (`docker exec -it rynek-postgres-1 psql -U postgres`) albo wyczyść dane lokalne: `docker compose -f local/docker-compose.yml down -v`.

## Planowana zawartość

- `local/`: docker-compose do lokalnego uruchomienia:
  - Kafka;
  - Redis (cache, limity w gateway);
  - Elasticsearch/OpenSearch (search-service);
  - magazyn S3-kompatybilny, np. MinIO (media-service).
- Później: wspólne workflow CI (GitHub Actions) i konfiguracja wdrożeń.

Sekretów (`JWT`, TikTok `client_secret`, klucze płatności) nie commitujemy. Do lokalnego uruchomienia służą pliki `.env`, które są w `.gitignore`.
