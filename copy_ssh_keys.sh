#!/bin/bash

HOSTLIST="$1"
PPASS="$2"

cat $HOSTLIST |\
  while read -r foo
   do 
     echo "Host = $foo"
     sshpass -p "${PPASS}" \
     ssh-copy-id \
     -o StrictHostKeyChecking=no \
     "$foo"
   done
