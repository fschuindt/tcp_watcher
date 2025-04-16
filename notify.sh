#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 \"notification message\""
  exit 1
fi

if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_BOT_CHAT_ID" ]; then
  echo "Error: TELEGRAM_BOT_TOKEN and TELEGRAM_BOT_CHAT_ID environment variables must be set."
  exit 1
fi

MESSAGE="$1"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
  -d chat_id="$TELEGRAM_BOT_CHAT_ID" \
  -d text="$MESSAGE"

echo "[$TIMESTAMP] $MESSAGE" >> notifications.log
