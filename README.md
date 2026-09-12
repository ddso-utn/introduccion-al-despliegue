# hola-mundo-express

Servidor Express mínimo expuesto a través de un proxy NGINX con caché HTTP de 5 minutos,
orquestado con Docker Compose.

## Requisitos

- [nvm](https://github.com/nvm-sh/nvm) (recomendado) o Node.js >= 24
- [pnpm](https://pnpm.io) >= 10.16

```bash
nvm use   # usa automáticamente Node 24 definido en .nvmrc
```

## Variables de entorno

| Variable       | Default        | Descripción                                      |
|----------------|----------------|--------------------------------------------------|
| `NODE_ENV`     | `development`  | Entorno de ejecución                             |
| `EMOJI_SALUDO` | `👋`           | Emoji que aparece en la respuesta del saludo     |
| `PORT`         | `3000`         | Puerto interno del servidor (opcional)           |

Las variables se configuran en el archivo `.env` (ver `.env` de ejemplo en el repo).

## Correr en local (sin Docker)

```bash
cp .env.example .env
pnpm install
pnpm start
# → http://localhost:3000
```

## Correr con Docker Compose

```bash
cp .env.example .env
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

## Restricción de versiones de paquetes

Configurado en `.npmrc` usando dos opciones nativas de pnpm >= 10.16:

- **`resolution-mode=time-based`**: resuelve versiones según las que existían al momento de la última modificación del `package.json`.
- **`minimum-release-age=10080`**: bloquea la instalación de versiones publicadas hace menos de 7 días (10080 minutos). Protección supply-chain: los paquetes comprometidos suelen ser detectados y removidos en horas.

## Estructura del proyecto

```
.
├── index.js           # Servidor Express
├── package.json
├── pnpm-lock.yaml     # Lockfile commiteado
├── .npmrc             # Configuración de pnpm (incluye minimum-release-age)
├── .nvmrc             # Node 24
├── .env               # Variables de entorno (no commiteado)
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── .gitignore
└── nginx/
    └── nginx.conf     # Proxy con caché HTTP
```
