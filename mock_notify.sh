#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 \"notification message\""
  exit 1
fi

echo "$1" >> notifications.csv
