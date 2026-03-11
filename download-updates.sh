#!/bin/bash
set -e

TOKEN=$(node -p "JSON.parse(require('fs').readFileSync('/root/.config/gws/credentials.json','utf8')).access_token")
echo "Token: ${TOKEN:0:20}..."

download() {
  local id="$1"
  local dest="$2"
  echo "Downloading $dest..."
  curl -L -s -H "Authorization: Bearer $TOKEN" "https://www.googleapis.com/drive/v3/files/$id?alt=media" -o "$dest"
  if [ -f "$dest" ]; then
    echo "✅ $dest saved"
  else
    echo "❌ Failed to download $dest"
    return 1
  fi
}

cd /root/.openclaw/workspace

download "1-7JpMASe8rRwi9hwxD8f2HfvNuyD89Mj" "README.md"
download "19zTaN3jFQvpzn2TRQvIlJxiKTadcYXw7" "AALM_analysis.R"
download "1YSTLMfzID-6jYf1_aUZtGaCItc_xmDJ3" "AAML.html"

echo ""
echo "✅ All files downloaded."
