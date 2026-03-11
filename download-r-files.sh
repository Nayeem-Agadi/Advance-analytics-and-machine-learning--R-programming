#!/bin/bash
set -e

# Get access token from credentials
TOKEN=$(node -p "JSON.parse(require('fs').readFileSync('/root/.config/gws/credentials.json','utf8')).access_token")
echo "✅ Token obtained (length: ${#TOKEN})"

# Function to find file ID by exact name
find_file_id() {
  local name="$1"
  echo "🔍 Searching for: $name"
  local resp=$(curl -s -H "Authorization: Bearer $TOKEN" "https://www.googleapis.com/drive/v3/files?q=name='${name}'&fields=files(id,name)&pageSize=10")
  # Extract first file ID
  local id=$(echo "$resp" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
  if [ -n "$id" ]; then
    echo "$id"
  else
    echo ""
  fi
}

# Download a file by ID
download_file() {
  local id="$1"
  local dest="$2"
  echo "⬇️  Downloading to $dest ..."
  curl -L -s -H "Authorization: Bearer $TOKEN" "https://www.googleapis.com/drive/v3/files/${id}?alt=media" -o "$dest"
  if [ -f "$dest" ]; then
    local size=$(stat -c%s "$dest" 2>/dev/null || stat -f%z "$dest" 2>/dev/null || echo "?")
    echo "✅ Saved ($size bytes)"
  else
    echo "❌ Download failed"
  fi
}

# Main
cd /root/.openclaw/workspace

# AALM.rmd
RMD_ID=$(find_file_id "AALM.rmd")
if [ -n "$RMD_ID" ]; then
  download_file "$RMD_ID" "AALM.rmd"
else
  echo "❌ AALM.rmd not found in Drive"
fi

# CSV
CSV_ID=$(find_file_id "student_merge_platform_business_file_final15.csv")
if [ -n "$CSV_ID" ]; then
  download_file "$CSV_ID" "student_merge_platform_business_file_final15.csv"
else
  echo "❌ student_merge_platform_business_file_final15.csv not found in Drive"
fi

echo ""
echo "✅ Drive download complete."
ls -lh AALM.rmd student_merge_platform_business_file_final15.csv 2>/dev/null || echo "Some files missing"
