# pass in the CVAL to calling the script
collection_id="$1"
range="$2"

list=($(/bin/grep -Hl MASTER_CORE_URL /var/solr/instance-[1-99]/"${collection_id}"_hierarchy/core.properties))
IFS=$'\n'

for config in "${list[@]}"
do
  cat "$config"
  echo
done
