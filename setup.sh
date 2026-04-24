#!/usr/bin/env bash
#
# setup.sh — Sobe o projeto do zero.
#
# Uso:
#   ./setup.sh                             # defaults: DB woocommerce_db, URL http://localhost/woocommerce
#   ./setup.sh http://loja.test            # já reescreve as URLs no dump pra sua URL local
#   DB_USER=root DB_PASSWORD=secret ./setup.sh
#
set -euo pipefail

cd "$(dirname "$0")"

DB_NAME="${DB_NAME:-woocommerce_db}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-}"
DB_HOST="${DB_HOST:-127.0.0.1}"
SITE_URL="${1:-${SITE_URL:-}}"

if command -v mysql >/dev/null; then
  MYSQL_BIN=(mysql)
elif command -v docker >/dev/null \
     && container=$(docker ps --format '{{.Names}}' 2>/dev/null | grep -m1 -E '^TO--mysql' || true) \
     && [ -n "$container" ]; then
  echo "→ Cliente mysql não encontrado no host; usando container do Takeout ($container)."
  MYSQL_BIN=(docker exec -i "$container" mysql)
  DB_HOST="127.0.0.1"
else
  echo "✗ Nenhum cliente mysql acessível."
  echo "  Instale 'mysql-client' (apt/brew) ou garanta que o Takeout/XAMPP esteja rodando."
  exit 1
fi

auth=(-h "$DB_HOST" -u "$DB_USER")
[ -n "$DB_PASSWORD" ] && auth+=(-p"$DB_PASSWORD")

echo "→ Criando banco '$DB_NAME' (se necessário)..."
"${MYSQL_BIN[@]}" "${auth[@]}" -e \
  "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci;"

echo "→ Importando dump (pode levar alguns segundos)..."
"${MYSQL_BIN[@]}" "${auth[@]}" "$DB_NAME" < database/woocommerce_db.sql

if [ ! -f wp-config.php ]; then
  echo "→ Gerando wp-config.php a partir do sample..."
  cp wp-config-sample.php wp-config.php
fi

if [ -n "${SITE_URL:-}" ] && [ "$SITE_URL" != "http://localhost/woocommerce" ]; then
  if command -v wp >/dev/null; then
    echo "→ Reescrevendo URL: http://localhost/woocommerce → $SITE_URL"
    WORDPRESS_DB_NAME="$DB_NAME" \
    WORDPRESS_DB_USER="$DB_USER" \
    WORDPRESS_DB_PASSWORD="$DB_PASSWORD" \
    WORDPRESS_DB_HOST="$DB_HOST" \
      wp search-replace 'http://localhost/woocommerce' "$SITE_URL" --all-tables --quiet
  else
    echo "! WP-CLI não encontrado. Para ajustar a URL manualmente, instale wp-cli e rode:"
    echo "    wp search-replace 'http://localhost/woocommerce' '$SITE_URL'"
  fi
fi

cat <<EOF

✓ Setup concluído.
  URL:      ${SITE_URL:-http://localhost/woocommerce}
  Admin:    admin / admin
  Banco:    $DB_NAME em $DB_HOST (user: $DB_USER)

Agora aponte seu servidor (Valet, Herd, XAMPP…) para esta pasta e abra a URL acima.
EOF
