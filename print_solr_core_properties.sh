# pass in the CVAL to calling the script
izz=$1
/bin/grep -H MASTER /var/solr/instance-[1-99]/"${izz}"_{content,attachments,hierarchy,participants}/core.properties 2>/dev/null
#/bin/grep -H MASTER /var/solr/instance-[1-99]/"${izz}"_{content,attachments,hierarchy}/core.properties

