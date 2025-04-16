#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 \"Label1, Port1, Expiry1\" \"Label2, Port2, Expiry2\" ..."
  exit 1
fi

declare -A recent_ips
declare -A expiry_map
declare -A label_map
port_filters=()

for entry in "$@"; do
  IFS=',' read -ra parts <<< "$entry"
  label=$(echo "${parts[0]}" | xargs)
  port=$(echo "${parts[1]}" | xargs)
  expiry=$(echo "${parts[2]}" | xargs)

  label_map["$port"]="$label"
  expiry_map["$port"]="$expiry"
  port_filters+=("tcp dst port $port")
done

# Build final tcpdump expression with ORs between filters
tcpdump_expr=""
for i in "${!port_filters[@]}"; do
  if [ "$i" -gt 0 ]; then
    tcpdump_expr+=" or "
  fi
  tcpdump_expr+="${port_filters[$i]}"
done

# Final filter string with TCP SYN but not ACK
full_filter="(${tcpdump_expr}) and tcp[13] & 2 != 0 and tcp[13] & 16 == 0"

# Debug output (optional)
# echo "tcpdump filter: $full_filter"

# Run tcpdump using eval to expand the expression properly
sudo tcpdump -l -n "$full_filter" | while read -r line; do
  ip=$(echo "$line" | awk '{print $5}' | cut -d. -f1-4)
  port=$(echo "$line" | awk '{print $5}' | awk -F. '{print $NF}' | cut -d':' -f1)

  now=$(date +%s)
  key="$ip:$port"
  last_seen=${recent_ips["$key"]:-0}
  expiry=${expiry_map[$port]}

  if (( now - last_seen >= expiry )); then
    recent_ips["$key"]=$now
    label=${label_map[$port]}
    echo "$label connection on IP $ip"
    ./notify.sh "$label connection on IP $ip" >/dev/null 2>&1
  fi
done
