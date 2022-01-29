#!/bin/bash

#Set default keepalive status (false to enable restart)
keepalive=FALSE

while getopts ":c:p:m:k:" o; do
    case "${o}" in
        c)
            izz=${OPTARG}
            ;;
        p)
            port=${OPTARG}
            ;;
	m)
            primary_server=${OPTARG}
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

#if [ -z "${izz}" ] || [ -z "${primary_server}" ] || [ -z "${port}" ]; then
#    usage
#fi

echo "Collection = ${izz}"
echo "Master = ${primary_server}"
echo "Port = ${port}"
echo "Keepalive (no restart) = ${keepalive}"

# Show current config for Collection
echo "Current config file:"
grep -H MASTER_CORE_URL /var/solr/instance-[1-99]/"${izz}"_{content,attachments,participants}/core.properties

containing_folders=($(grep -H MASTER_CORE_URL \
  /var/solr/instance-[1-99]/"${izz}"_{content,attachments,participants}/core.properties |\
  cut -d  ':'  -f 1 |\
  xargs -L 1 dirname))

echo "Files to change:"
echo "${containing_folders[@]}"

# Edit core.properties
for config_path in "${containing_folders[@]}"
do
  sed -i.bak -e \
    's!\(MASTER_CORE_URL=\).*\(\\\)!MASTER_CORE_URL='"${primary_server}"'\\!g' \
    -e 's!\:[0-9][0-9][0-9][0-9]!':"${port}"'!' \
    ${config_path}/core.properties
#  sed -i.bak "s/${old_primary}/${primary_server}/g" ${config_path}/core.properties
done

echo "Changed files:"
grep -H MASTER_CORE_URL /var/solr/instance-[1-99]/"${izz}"_hierarchy/core.properties

# restart affected hierarchy instances
service_list=$(mktemp)

grep -H MASTER_CORE_URL /var/solr/instance-[1-99]/"${izz}"_hierarchy/core.properties |\
  grep -E -o 'instance-[1-99]'|\
  sed 's/instance-/solr-0/g'|\
    while read -r restart_instance
    do
      echo "service restarted [$restart_instance]" >> "$service_list"
      if [[ "$keepalive" != "TRUE" ]]; then
        sudo /sbin/service $restart_instance restart
      else
        echo "[$restart_instance] not restarted. Keepalive is set"
      fi
    done

echo "Collection: ${izz}"
echo "Changed files:"
grep -H MASTER_CORE_URL /var/solr/instance-[1-99]/"${izz}"_hierarchy/core.properties
echo "hostname: " `hostname`
cat "$service_list"

