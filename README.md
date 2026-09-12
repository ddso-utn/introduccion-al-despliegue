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

## Despliegue en IaaS

### Nativo

```bash
# conectarse por
ssh root@MI-IP

# instalar nvm
sudo apt-get update
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash
 . .bashrc

# descargar el código
git clone https://github.com/ddso-utn/introduccion-al-despliegue.git

# instalar la aplicación
cd introduccion-al-despliegue/
nvm install
corepack enable && corepack prepare pnpm@10.16.0 --activate
pnpm install --frozen-lockfile --prod

# iniciar la aplicación
pnpm start
# iniciarla en segundo plano
pnpm start > server.log 2>&1 &

# pendiente: configurar por ejemplo ufw y monit o similar
# consultar ahora http://MI-IP:3000/
```

### Con Docker

> Nota: si vas a construir localmente en lugar de en el servidor (lo recomendando)
> es necesario crear una cuenta y un repositorio en dockerhub y hacer un push:
>
> docker push flbulgarelli/introduccion-al-despliegue:0.1

```bash
# instalar docker
sudo apt-get update
sudo apt-get install docker.io
# dependiendo de la versión de docker / ubuntu puede no ser necesario
sudo apt-get install docker-compose
```

## Despliegue en PaaS

> Ejemplo usando [Render](https://render.com/)
>

### 1. Creá una aplicación

[Screencast from 11-09-26 22:41:49.webm](https://github.com/user-attachments/assets/4e444b42-1cfe-4bf8-a931-c219f3f6fb1e)

### 2. Configurá la aplicación

#### a. Despliegue nativo

[Screencast from 11-09-26 22:43:24.webm](https://github.com/user-attachments/assets/27e3e721-6863-4b4e-8381-569c98cf6b4d)

[Screencast from 11-09-26 22:43:48.webm](https://github.com/user-attachments/assets/37d7b69d-964e-4561-99f7-681cd86401a5)

[Screencast from 11-09-26 22:44:53.webm](https://github.com/user-attachments/assets/1675a149-5229-42ad-8a80-e5e624f33f95)

[Screencast from 11-09-26 22:45:26.webm](https://github.com/user-attachments/assets/1f0a73af-a15f-458b-823b-a40a80fc44fc)


#### b. Despliegue con Docker


[Screencast from 11-09-26 22:47:22.webm](https://github.com/user-attachments/assets/4714de51-e333-4bf1-bf5b-db4f16864db2)


### 3. Cambio de variables de entorno

[Screencast from 11-09-26 22:49:47.webm](https://github.com/user-attachments/assets/403bfd20-4b29-4bc5-8a8d-02d28c6e9947)
