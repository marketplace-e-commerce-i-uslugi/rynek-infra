# rynek-infra

Infrastruktura platformy **Rynek**.

> Status: **w budowie**. `local/docker-compose.yml` zawiera na razie tylko Redis (limity w api-gateway).

```bash
docker compose -f local/docker-compose.yml up -d
```

## Planowana zawartość

- `local/`: docker-compose do lokalnego uruchomienia:
  - PostgreSQL (osobna baza na serwis);
  - Kafka;
  - Redis (cache, limity w gateway);
  - Elasticsearch/OpenSearch (search-service);
  - magazyn S3-kompatybilny, np. MinIO (media-service).
- Później: wspólne workflow CI (GitHub Actions) i konfiguracja wdrożeń.

Sekretów (`JWT`, TikTok `client_secret`, klucze płatności) nie commitujemy. Do lokalnego uruchomienia służą pliki `.env`, które są w `.gitignore`.
