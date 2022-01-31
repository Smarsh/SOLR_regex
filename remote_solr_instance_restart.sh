#!/bin/bash

if [  -z "$1" ]; then
  echo "Missing instance to restart"
  exit
fi

echo "[`hostname`] restarting SOLR instance [$1]"
restart_instance=$(printf "solr-%02d" "$1")

sudo /sbin/service $restart_instance restart
