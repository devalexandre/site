# Deploying

---

{% note info WIP Documentation %}

<img src="assets/under_construction.png" width=150/>

This documentation is still a working in progress and this page has not been fully converted yet :(

We are working on top of the existing Moleculer JS documentation, and that is why you might see pages with some JavaScript :)
{% endnote %}

## Dockerfile to run Moleculer services

```docker
FROM node:8-alpine

ENV NODE_ENV=production

RUN mkdir /app
WORKDIR /app

COPY package.json .

RUN npm install --production

COPY . .

CMD ["npm", "start"]
```

## Docker Compose file to run Moleculer services with NATS & Traefik (load balancing the API Gateway)

```yaml
version: "3.0"

services:
    api:
        build:
            context: .
        image: moleculer-demo
        env_file: docker-compose.env
        environment:
            SERVICES: api
            PORT: 3000
        links:
            - nats
        depends_on:
            - nats
        labels:
            - "traefik.enable=true"
            - "traefik.backend=api"
            - "traefik.port=3000"
            - "traefik.frontend.entryPoints=http"
            - "traefik.frontend.rule=PathPrefix:/"

    greeter:
        build:
            context: .
        image: moleculer-demo
        env_file: docker-compose.env
        environment:
            SERVICES: greeter
        links:
            - nats
        depends_on:
            - nats

    nats:
        image: nats

    traefik:
        image: traefik
        command: --web --docker --docker.domain=docker.localhost --logLevel=INFO --docker.exposedbydefault=false
        ports:
            - "3000:80"
            - "3001:8080"
        volumes:
            - /var/run/docker.sock:/var/run/docker.sock
            - /dev/null:/traefik.toml
```

**Start containers**

```bash
$ docker-compose up -d
```

Access your app on `http://<docker-host>:3000/`. Traefik dashboard UI on `http://<docker-host>:3001/`
