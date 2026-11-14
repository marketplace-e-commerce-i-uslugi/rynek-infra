# rynek-infra

Infrastruktura platformy **Rynek**.

> Status: **w budowie**. `local/docker-compose.yml` zawiera Redis (limity w api-gateway), PostgreSQL, SeaweedFS (magazyn S3 dla media-service) Kafka (KRaft, jeden broker; fundament pod zdarzenia, serwisy jeszcze z niej nie korzystają) i OpenSearch (indeks search-service).

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
| cart-service | `cart` | `cart` / `cart` |
| order-service | `orders` | `orders` / `orders` |
| payment-service | `payments` | `payments` / `payments` |
| feed-service | `feed` | `feed` / `feed` |

Skrypt z `postgres/init` wykonuje się tylko przy pierwszym starcie pustego wolumenu. Po dopisaniu nowej bazy wykonaj jej blok ręcznie (`docker exec -it rynek-postgres-1 psql -U postgres`) albo wyczyść dane lokalne: `docker compose -f local/docker-compose.yml down -v`.

## Magazyn plików (SeaweedFS)

media-service trzyma pliki w magazynie S3-kompatybilnym. Lokalnie to SeaweedFS (`chrislusf/seaweedfs`, API S3 na porcie 8333). Oficjalne obrazy MinIO zniknęły z Docker Hub, a SeaweedFS ma licencję Apache 2.0 i aktualne obrazy.

- Klucze serwisu i uprawnienia są w `local/seaweedfs/s3.json`: `rynek-media` / `rynek-media-local`, lokalne i jawne celowo.
- Kubełek `rynek-media-public` (zdjęcia ofert, awatary, banery) ma anonimowy odczyt, bo przeglądarka ładuje pliki ze stałego adresu. `rynek-media-private` (dokumenty weryfikacji, załączniki czatu) jest dostępny tylko przez podpisane URL-e.
- Kubełki i reguły CORS (wysyłka z `http://localhost:4200`) zakłada media-service przy starcie.
- Pliki: `http://localhost:8333/rynek-media-public/<klucz>`.

## Kafka

Jeden broker w trybie KRaft (bez ZooKeepera), obraz `apache/kafka:3.9.0`, dane w wolumenie `kafka-data`.

- Z hosta (serwisy uruchamiane przez `./mvnw spring-boot:run`): `localhost:9092`.
- Z kontenera w sieci compose: `kafka:29092`.
- Tematy mają nazwy zdarzeń (`order.cancelled`, `payment.paid` itd.) i zakładają się automatycznie (`KAFKA_AUTO_CREATE_TOPICS_ENABLE`, tylko lokalnie).
- Healthcheck: `kafka-broker-api-versions.sh`. Pierwszy start trwa do kilkudziesięciu sekund.
- Podgląd tematów: `docker compose -f local/docker-compose.yml exec kafka /opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list`.
- Schematy zdarzeń i plan zastąpienia wywołań `/internal`: `rynek-contracts/events` oraz `rynek-contracts/docs/migracja-z-wywolan-synchronicznych.md`.

## OpenSearch

Jeden węzeł `opensearchproject/opensearch:2.19.1` (`localhost:9200`), bez uwierzytelniania i TLS, tylko do pracy lokalnej, pamięć JVM 512 MB, dane w wolumenie `opensearch-data`. Indeksy `offers` (alias) i `channels` zakłada i utrzymuje search-service. Zdrowie: `curl localhost:9200/_cluster/health`. Pierwszy start trwa do kilkudziesięciu sekund.

## Planowana zawartość

- `local/`: docker-compose do lokalnego uruchomienia:
  - Redis (cache, limity w gateway).
- Później: wspólne workflow CI (GitHub Actions) i konfiguracja wdrożeń.

Sekretów (`JWT`, TikTok `client_secret`, klucze płatności) nie commitujemy. Do lokalnego uruchomienia służą pliki `.env`, które są w `.gitignore`.
