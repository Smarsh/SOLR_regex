#!/bin/bash

if [ -z "$1" ]; then
  echo "Pass in a file to parse. Expecting host list strings"
  echo "Example: http://nd-absdef.smarshinc.com:8080/solr/old.html#/C1141_hierarchy/replication"
  exit
else
  hostlist="$1"
fi

sorted_hosts=$(mktemp -t hosts_sorted)
sorted_collections=$(mktemp -t collections_sorted)

cat "$hostlist" | sed -e 's@http://@@g' |cut -d ':' -f 1|sort -u > "$sorted_hosts"

echo "HOSTLIST=${sorted_hosts}"
cat "$sorted_hosts"
