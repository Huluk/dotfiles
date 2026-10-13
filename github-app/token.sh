#!/bin/bash
# Print a GitHub App installation token, cached for up to 50 minutes.

DIR="$HOME/.config/github-app"
CACHE="$DIR/token.cache"

if [[ -s $CACHE && -n $(find "$CACHE" -mmin -50) ]]; then
  cat "$CACHE"
  exit
fi

source "$DIR/env"
: "${CLIENT_ID:?}" "${INSTALLATION_ID:?}"
KEY_FILE="$DIR/private-key.pem"

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }

now=$(date +%s)
header=$(printf '{"alg":"RS256","typ":"JWT"}' | b64url)
payload=$(printf '{"iat":%d,"exp":%d,"iss":"%s"}' \
  "$((now - 60))" "$((now + 540))" "$CLIENT_ID" | b64url)
signature=$(printf '%s' "$header.$payload" \
  | openssl dgst -sha256 -sign "$KEY_FILE" -binary | b64url)

token=$(curl -s -X POST \
  -H "Authorization: Bearer $header.$payload.$signature" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/app/installations/$INSTALLATION_ID/access_tokens" \
  | sed -n 's/.*"token": *"\([^"]*\)".*/\1/p')

[[ -n $token ]] || exit 1
(umask 077; printf '%s' "$token" > "$CACHE")
printf '%s\n' "$token"
