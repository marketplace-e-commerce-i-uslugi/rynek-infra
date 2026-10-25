-- Osobna baza i konto na serwis (PostgreSQL per serwis). Skrypt działa tylko przy pierwszym starcie pustego wolumenu;
-- po dopisaniu serwisu: docker compose -f local/docker-compose.yml down -v (kasuje dane lokalne) albo wykonaj blok ręcznie.
-- Hasła są lokalne i jawne celowo; w innych środowiskach serwisy dostają je ze zmiennych środowiskowych.

CREATE USER identity WITH PASSWORD 'identity';
CREATE DATABASE identity OWNER identity;

CREATE USER channel WITH PASSWORD 'channel';
CREATE DATABASE channel OWNER channel;
