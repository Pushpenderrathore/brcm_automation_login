#!/bin/bash

# Connect to network in case network is not saved
nmcli device wifi connect "Bhabha 1"

# Portal URL
URL="http://10.10.10.1:8090/login.xml"   # this is the actual backend (not httpclient.html)

# List of credentials (username:password)
CREDENTIALS=(
  "cse4956:495665"
  "cse4957:495775"
  "cse4958:495885"
  # Add more here
)

# Try each credential until login succeeds
for cred in "${CREDENTIALS[@]}"; do
  USERNAME="${cred%%:*}"
  PASSWORD="${cred##*:}"

  echo "Trying with $USERNAME..."

  RESPONSE=$(curl -s -X POST "$URL" \
    -d "mode=191" \
    -d "username=$USERNAME" \
    -d "password=$PASSWORD" \
    -d "a=$(date +%s)" \
    -d "producttype=0")

  echo "Response:"
  echo "$RESPONSE"
  echo "-------------------------"

  if echo "$RESPONSE" | grep -q "LIVE"; then
    echo "✅ Logged in with $USERNAME"

    # --- Fix DNS after successful login ---
    echo "🔧 Setting DNS to Google (8.8.8.8, 8.8.4.4)"
    nmcli connection modify "Bhabha 1" ipv4.dns "8.8.8.8 8.8.4.4"
    nmcli connection modify "Bhabha 1" ipv4.ignore-auto-dns yes
    nmcli connection up "Bhabha 1"

    echo "🌍 Testing connectivity..."
    ping -c 3 8.8.8.8
    ping -c 3 google.com

    break
  else
    echo "❌ Failed with $USERNAME, trying next..."
  fi
done
