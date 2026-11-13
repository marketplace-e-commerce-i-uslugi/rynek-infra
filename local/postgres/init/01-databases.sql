-- Osobna baza i konto na serwis (PostgreSQL per serwis). Skrypt działa tylko przy pierwszym starcie pustego wolumenu;
-- po dopisaniu serwisu: docker compose -f local/docker-compose.yml down -v (kasuje dane lokalne) albo wykonaj blok ręcznie.
-- Hasła są lokalne i jawne celowo; w innych środowiskach serwisy dostają je ze zmiennych środowiskowych.

CREATE USER identity WITH PASSWORD 'identity';
CREATE DATABASE identity OWNER identity;

CREATE USER channel WITH PASSWORD 'channel';
CREATE DATABASE channel OWNER channel;

CREATE USER catalog WITH PASSWORD 'catalog';
CREATE DATABASE catalog OWNER catalog;

CREATE USER media WITH PASSWORD 'media';
CREATE DATABASE media OWNER media;

CREATE USER cart WITH PASSWORD 'cart';
CREATE DATABASE cart OWNER cart;

CREATE USER orders WITH PASSWORD 'orders';
CREATE DATABASE orders OWNER orders;

CREATE USER payments WITH PASSWORD 'payments';
CREATE DATABASE payments OWNER payments;

CREATE USER shipping WITH PASSWORD 'shipping';
CREATE DATABASE shipping OWNER shipping;

CREATE USER bookings WITH PASSWORD 'bookings';
CREATE DATABASE bookings OWNER bookings;

CREATE USER engagement WITH PASSWORD 'engagement';
CREATE DATABASE engagement OWNER engagement;

CREATE USER notifications WITH PASSWORD 'notifications';
CREATE DATABASE notifications OWNER notifications;
