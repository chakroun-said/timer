#!/usr/bin/env bash
# Installs the Workout Timer PWA into nginx on the EC2 host.
#
# Uploaded next to web.tar.gz and the two nginx configs, then run with
#   SERVER_NAME=<ip-or-domain> bash install.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARCHIVE="$HERE/web.tar.gz"
SERVER_NAME="${SERVER_NAME:?SERVER_NAME is required}"
ROOT=/var/www/workouts-timer
STAGE=/var/www/workouts-timer.new

# Install the release beside the live one and swap, so the site is never served
# from a half-extracted directory.
sudo rm -rf "$STAGE"
sudo mkdir -p "$STAGE"
sudo tar -xzf "$ARCHIVE" -C "$STAGE"
sudo chown -R www-data:www-data "$STAGE"
sudo find "$STAGE" -type d -exec chmod 755 {} +
sudo find "$STAGE" -type f -exec chmod 644 {} +

sudo rm -rf "$ROOT.old"
if [ -d "$ROOT" ]; then sudo mv "$ROOT" "$ROOT.old"; fi
sudo mv "$STAGE" "$ROOT"

# A certificate is what turns the site into a secure context, which the service
# worker and the install prompt require. A Let's Encrypt certificate for this
# name is preferred; without one the only option is a self-signed certificate,
# which browsers refuse to treat as installable.
LE_DIR="/etc/letsencrypt/live/$SERVER_NAME"
if sudo test -f "$LE_DIR/fullchain.pem"; then
  CERT_PATH="$LE_DIR/fullchain.pem"
  KEY_PATH="$LE_DIR/privkey.pem"
  echo "using the Let's Encrypt certificate for $SERVER_NAME"
else
  CERT_PATH=/etc/nginx/ssl/workouts-timer.crt
  KEY_PATH=/etc/nginx/ssl/workouts-timer.key

  if [[ "$SERVER_NAME" =~ ^[0-9]+(\.[0-9]+){3}$ ]]; then
    SAN="IP:$SERVER_NAME"
    CHECK=(-checkip "$SERVER_NAME")
  else
    SAN="DNS:$SERVER_NAME"
    CHECK=(-checkhost "$SERVER_NAME")
  fi

  if ! sudo test -f "$CERT_PATH" || ! sudo openssl x509 -in "$CERT_PATH" -noout "${CHECK[@]}" >/dev/null 2>&1; then
    sudo mkdir -p /etc/nginx/ssl
    sudo openssl req -x509 -nodes -newkey rsa:2048 -days 825 \
      -keyout "$KEY_PATH" -out "$CERT_PATH" \
      -subj "/CN=$SERVER_NAME" -addext "subjectAltName=$SAN" >/dev/null 2>&1
    sudo chmod 600 "$KEY_PATH"
    echo "generated self-signed certificate for $SERVER_NAME"
  fi
fi

sudo mkdir -p /etc/nginx/snippets
sudo install -m 644 "$HERE/workouts-timer-app.conf" /etc/nginx/snippets/workouts-timer-app.conf
sed -e "s|__SERVER_NAME__|$SERVER_NAME|g" \
    -e "s|__CERT_PATH__|$CERT_PATH|g" \
    -e "s|__KEY_PATH__|$KEY_PATH|g" \
    "$HERE/workouts-timer.conf" > /tmp/workouts-timer-site.conf
sudo install -m 644 /tmp/workouts-timer-site.conf /etc/nginx/sites-available/workouts-timer
sudo ln -sf /etc/nginx/sites-available/workouts-timer /etc/nginx/sites-enabled/workouts-timer
sudo rm -f /etc/nginx/sites-enabled/default

sudo nginx -t 2>&1
sudo systemctl reload nginx

echo "deployed $ROOT for $SERVER_NAME"
