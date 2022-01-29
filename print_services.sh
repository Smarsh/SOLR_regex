#!/bin/bash


while IFS= read -r line; do
  if [[ "$line" == *"nd-"* ]]; then
    if [[ $n -gt 0 ]]; then 
      echo "$n"
    fi
    n=0
    hostname="$line"
    echo -n "$hostname: "
  fi
  if [[ "$line" == *"instance"* ]]; then
    n=$((n+1))
  fi
done < "$1"
