# rynek-infra

Infrastruktura platformy **Rynek**.

> Status: **w budowie**. `local/docker-compose.yml` zawiera Redis (limity w api-gateway), PostgreSQL i SeaweedFS (magazyn S3 dla media-service).

```bash
docker compose -f local/docker-compose.yml up -d
```

## PostgreSQL

Lokalnie jeden kontener, ale każdy serwis ma własną bazę i konto (`local/postgres/init/01-databases.sql`):

| Serwis | Baza | Użytkownik / hasło |
|---|---|---|
| identity-service | `identity` | `identity` / `identity` |
| channel-service | `channel` | `channel` / `channel` |
| catalog-service | `catalog` | `catalog` / `catalog` |
| media-service | `media` | `media` / `media` |

Skrypt z `postgres/init` wykonuje się tylko przy pierwszym starcie pustego wolumenu. Po dopisaniu nowej bazy wykonaj jej blok ręcznie (`docker exec -it rynek-postgres-1 psql -U postgres`) albo wyczyść dane lokalne: `docker compose -f local/docker-compose.yml down -v`.

## Magazyn plików (SeaweedFS)

media-service trzyma pliki w magazynie S3-kompatybilnym. Lokalnie to SeaweedFS (`chrislusf/seaweedfs`, API S3 na porcie 8333). Oficjalne obrazy MinIO zniknęły z Docker Hub, a SeaweedFS ma licencję Apache 2.0 i aktualne obrazy.

- Klucze serwisu i uprawnienia są w `local/seaweedfs/s3.json`: `rynek-media` / `rynek-media-local`, lokalne i jawne celowo.
- Kubełek `rynek-media-public` (zdjęcia ofert, awatary, banery) ma anonimowy odczyt, bo przeglądarka ładuje pliki ze stałego adresu. `rynek-media-private` (dokumenty weryfikacji, załączniki czatu) jest dostępny tylko przez podpisane URL-e.
- Kubełki i reguły CORS (wysyłka z `http://localhost:4200`) zakłada media-service przy starcie.
- Pliki: `http://localhost:8333/rynek-media-public/<klucz>`.

## Planowana zawartość

- `local/`: docker-compose do lokalnego uruchomienia:
  - Kafka;
  - Redis (cache, limity w gateway);
  - Elasticsearch/OpenSearch (search-service).
- Później: wspólne workflow CI (GitHub Actions) i konfiguracja wdrożeń.

Sekretów (`JWT`, TikTok `client_secret`, klucze płatności) nie commitujemy. Do lokalnego uruchomienia służą pliki `.env`, które są w `.gitignore`.
