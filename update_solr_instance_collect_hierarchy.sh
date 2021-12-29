#!/bin/bash

#Set default keepalive status (false to enable restart)
keepalive=FALSE

while getopts ":c:m:d:k:" o; do
    case "${o}" in
        c)
            izz=${OPTARG}
            ;;
	m)
            primary_server=${OPTARG}
            ;;
	d)
            old_primary=${OPTARG}
            ;;
	k)
            keepalive=${OPTARG}
            ;;
	*)
            usage
            ;;
    esac
done

shift $((OPTIND-1))

if [ -z "${izz}" ] || [ -z "${primary_server}" ] || [ -z "${old_primary}" ]; then
    usage
fi

echo "Collection = ${izz}"
echo "Master = ${primary_server}"
echo "Dead Master = ${old_primary}"
echo "Keepalive (no restart) = ${keepalive}"

# Show current config for Collection
echo "Current config file:"
grep -H MASTER /var/solr/instance-[1-99]/"${izz}"_hierarchy/core.properties

containing_folders=($(grep -H MASTER \
  /var/solr/instance-[1-99]/"${izz}"_hierarchy/core.properties |\
  cut -d  ':'  -f 1 |\
  xargs -L 1 dirname))

echo "Files to change:"
echo "${containing_folders[@]}"

# Edit core.properties
for config_path in "${containing_folders[@]}"
do
  sed -i.bak "s/${old_primary}/${primary_server}/g" ${config_path}/core.properties
done

echo "Changed files:"
grep -H MASTER /var/solr/instance-[1-99]/"${izz}"_hierarchy/core.properties

# restart affected hierarchy instances
service_list=$(mktemp)

grep -H MASTER /var/solr/instance-[1-99]/"${izz}"_hierarchy/core.properties |\
  grep -E -o 'instance-[1-99]'|\
  sed 's/instance-/solr-0/g'|\
    while read -r restart_instance
    do
      echo "service restarted [$restart_instance]" >> "$service_list"
      if [[ "$keepalive" != "TRUE" ]]; then
        sudo /sbin/service $restart_instance restart
      else
        echo "[$restart_instance] not restarted. Keepalive is set"
    done

echo "Collection: ${izz}"
echo "Changed files:"
grep -H MASTER /var/solr/instance-[1-99]/"${izz}"_hierarchy/core.properties
echo "hostname: " `hostname`
cat "$service_list"

