# hola-mundo-express

Servidor Express mínimo expuesto a través de un proxy NGINX con caché HTTP de 5 minutos,
orquestado con Docker Compose.

## Variables de entorno

| Variable       | Default        | Descripción                                      |
|----------------|----------------|--------------------------------------------------|
| `NODE_ENV`     | `development`  | Entorno de ejecución                             |
| `EMOJI_SALUDO` | `👋`           | Emoji que aparece en la respuesta del saludo     |
| `PORT`         | `3000`         | Puerto interno del servidor (opcional)           |

Las variables se configuran en el archivo `.env` (ver `.env` de ejemplo).

## Correr en local (sin Docker)

```bash
npm install
npm start
# → http://localhost:3000
```

## Correr con Docker Compose

```bash
docker compose up --build
# → http://localhost
```

## Verificar el caché NGINX

Hacer dos requests consecutivos y observar el header `X-Cache-Status`:

```bash
# Primera request — sin caché
curl -i http://localhost/
# X-Cache-Status: MISS

# Segunda request — respuesta cacheada por 5 minutos
curl -i http://localhost/
# X-Cache-Status: HIT
```

## Estructura del proyecto

```
.
├── index.js              # Servidor Express
├── package.json
├── .env                  # Variables de entorno (no commiteado)
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── .gitignore
└── nginx/
    └── nginx.conf        # Proxy con caché HTTP
```
