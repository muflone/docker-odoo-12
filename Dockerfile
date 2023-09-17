FROM debian:10.13-slim

# Install requirements
RUN apt-get --assume-yes update && \
    apt-get --assume-yes --no-install-recommends install \
        build-essential git wget \
        node-less wkhtmltopdf \
        python3-pip python3-dev python3-venv python3-wheel python3-setuptools \
        libxslt-dev libzip-dev libldap2-dev libsasl2-dev libjpeg-dev libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Odoo
RUN useradd -m -d /opt/odoo -U -r -s /bin/bash odoo && \
    su odoo -c 'git clone https://github.com/odoo/odoo.git --depth 1 --branch 12.0 /opt/odoo/src' && \
    python3 -m venv /opt/odoo/venv && \
    /opt/odoo/venv/bin/python3 -m pip install wheel && \
    sed -i 's/gevent==1.5.0/gevent==1.3.7/' /opt/odoo/src/requirements.txt && \
    /opt/odoo/venv/bin/python3 -m pip install -r /opt/odoo/src/requirements.txt

LABEL APP="Odoo 12"
EXPOSE 8069/tcp \
       8072/tcp
USER odoo
WORKDIR /opt/odoo/src
VOLUME ["/opt/odoo/data"]
VOLUME ["/opt/odoo/logs"]

ENV ODOO_VERSION=12.0 \
    ODOO_DATABASE_HOST=postgres \
    ODOO_DATABASE_PORT=5432 \
    ODOO_DATABASE_USER=postgres \
    ODOO_DATABASE_PASSWORD=password \
    ODOO_RC=/opt/odoo/odoo.conf \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY launch.sh "/opt/odoo/"
ENTRYPOINT ["bash", "-c", "/opt/odoo/launch.sh"]
