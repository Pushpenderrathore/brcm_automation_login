#!/bin/bash

# Connect to network in case network is not saved
nmcli device wifi connect "Bhabha 1"
nmcli device wifi connect "Wavion-1"

# Portal URL
URL="http://10.10.10.1:8090/login.xml"
 

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
  echo "------------------------"

  if echo "$RESPONSE" | grep -q "LIVE"; then
    echo "Logged in with $USERNAME"
    break
  else
    echo "Failed with $USERNAME, trying next..."
  fi
done
