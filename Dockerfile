FROM debian:10.13-slim

LABEL APP="Odoo 12"
ENV ODOO_HOME="/opt/odoo" \
    ODOO_VERSION=12.0 \
    ODOO_DATABASE_HOST=postgres \
    ODOO_DATABASE_PORT=5432 \
    ODOO_DATABASE_USER=postgres \
    ODOO_DATABASE_PASSWORD=password \
    ODOO_RC="${ODOO_HOME}/opt/odoo/odoo.conf" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

# Install requirements
RUN apt-get --assume-yes update && \
    apt-get --assume-yes --no-install-recommends install \
        build-essential git wget \
        node-less wkhtmltopdf \
        python3-pip python3-dev python3-venv python3-wheel python3-setuptools \
        libxslt-dev libzip-dev libldap2-dev libsasl2-dev libjpeg-dev libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Odoo
RUN useradd -m -d "${ODOO_HOME}" -U -r -s /bin/bash odoo && \
    su odoo -c "git clone https://github.com/odoo/odoo.git --depth 1 --branch 12.0 "${ODOO_HOME}/src"" && \
    python3 -m venv "${ODOO_HOME}/venv" && \
    "${ODOO_HOME}/venv/bin/python3" -m pip install wheel && \
    sed -i 's/gevent==1.5.0/gevent==1.3.7/' "${ODOO_HOME}/src/requirements.txt" && \
    "${ODOO_HOME}/venv/bin/python3" -m pip install -r "${ODOO_HOME}/src/requirements.txt"

# Configure Odoo
RUN install -d -m 755 -o odoo -g odoo "${ODOO_HOME}/data" \
    install -d -m 755 -o odoo -g odoo "${ODOO_HOME}/logs"

USER odoo
WORKDIR "${ODOO_HOME}/src"
VOLUME ["${ODOO_HOME}/data"]
VOLUME ["${ODOO_HOME}/logs"]
EXPOSE 8069/tcp \
       8072/tcp

COPY launch.sh "${ODOO_HOME}/launch.sh"
COPY odoo.conf "${ODOO_RC}"
ENTRYPOINT ["bash", "-c", "/opt/odoo/launch.sh"]

