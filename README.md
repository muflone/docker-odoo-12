# Docker Odoo 12

**Description:** Docker for Odoo 12

**Copyright:** 2023 Fabio Castelli (Muflone) <muflone(at)muflone.com>

**License:** GPL-3+

**Source code:** https://github.com/muflone/docker-odoo12

**Documentation:** http://www.muflone.com/docker-containers/

# System Requirements

* Docker (tested using v.24.05)

# Installation

Build the container using Docker build with:

    docker build -t author/name:version .

or using Docker buildx with:

    docker buildx build -t author/name:version .

# Usage

To use Odoo you need also a running Postgres database. You can setup them both
using docker compose:

```yaml
version: '3'

services:
  app:
    image: ilmuflone/odoo-12:0.2.0
    restart: 'no'
    ports:
      - "8069:8069"
    env_file:
      - app.env
    volumes:
      - ./data:/opt/odoo/data
      - ./logs:/opt/odoo/logs

  db:
     image: postgres:15.3
     restart: 'no'
     volumes:
       - ./database:/var/lib/postgresql/data
     env_file:
       - ./database.env
```

Set your Postgres administrator credentials in database.env:

```
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin
```

While you can setup your Postgres user credentials in app.env:

```
ODOO_DATABASE_HOST: db
ODOO_DATABASE_PORT: 5432
ODOO_DATABASE_USER: odoo
ODOO_DATABASE_PASSWORD: odoo
```

Finally start your containers using:

    docker compose up -d

