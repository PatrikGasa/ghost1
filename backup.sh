#!/bin/bash

# Nastavenia
API_URL="https://www.zhenaya.com/ghost/api/admin/db/"
ADMIN_API_KEY_ID="6863ac927c18800001dc99f9"
ADMIN_API_SECRET="c51e5c32ffcb5dd6cc4bdac7c022ef4bae116726ea2c42fb39f2a32770ca8d5e"
BACKUP_DIR="/var/lib/ghost/content/backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT="$BACKUP_DIR/zhenaya_backup_$DATE.json"

# Skontroluj, že adresár existuje
mkdir -p "$BACKUP_DIR"

# Vygeneruj JWT token
HEADER_BASE64=$(echo -n '{"alg":"HS256","typ":"JWT","kid":"'"$ADMIN_API_KEY_ID"'"}' | openssl base64 -A | tr '+/' '-_' | tr -d '=')
PAYLOAD_BASE64=$(echo -n '{"iat":'"$(date +%s)"',"exp":'"$(($(date +%s)+300))"',"aud":"admin"}' | openssl base64 -A | tr '+/' '-_' | tr -d '=')
SIGNATURE=$(echo -n "$HEADER_BASE64.$PAYLOAD_BASE64" | openssl dgst -binary -sha256 -hmac "$ADMIN_API_SECRET" | openssl base64 -A | tr '+/' '-_' | tr -d '=')
TOKEN="$HEADER_BASE64.$PAYLOAD_BASE64.$SIGNATURE"

# Zavolaj API a ulož zálohu
curl -L "$API_URL" \
  -H "Authorization: Ghost $TOKEN" \
  -o "$OUTPUT"

echo "✅ Záloha uložená do $OUTPUT"
