#!/bin/bash

cd "/opt/odoo/src"
/opt/odoo/venv/bin/python3 odoo-bin \
  -c "$ODOO_RC" \
  --db_host "$ODOO_DATABASE_HOST" \
  --db_port "$ODOO_DATABASE_PORT" \
  --db_user "$ODOO_DATABASE_USER" \
  --db_password "$ODOO_DATABASE_PASSWORD"

