# pass in the CVAL to calling the script
collection_id=$1

/bin/grep -H MASTER /var/solr/instance-[1-99]/"${collection_id}"_{content,attachments,hierarchy,participants}/core.properties 2>/dev/null


