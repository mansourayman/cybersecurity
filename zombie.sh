#!/usr/bin/env bash

if [ -f "$1" ]; then
  while IFS= read -r line; do
    number1=$(sudo hping3 -S -p 80 -c 1 "$line" 2>&1 | grep -Eo "id=[0-9]{1,10}" | cut -d '=' -f2)

    # if no id was found, skip this host
    if [ -z "$number1" ]; then
      continue
    fi

    number2=$(sudo hping3 -S -p 80 -c 1 "$line" 2>&1 | grep -Eo "id=[0-9]{1,10}" | cut -d '=' -f2)

    if [ -z "$number2" ]; then
      continue
    fi

    # numeric check: does it increment by 1?
    if (( number2 - number1 == 1 )); then
      echo "[*] $line"
    fi
  done < "$1"
else
  echo "Error: file not found"
  exit 1
fi
