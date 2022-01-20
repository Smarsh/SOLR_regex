# SOLR_regex
SOLR Regex Patterns for in bash

#### Print out properties with `print_solr_core_properties`

```
 ssh -n -T nd-91005.smarshinc.com "sudo /bin/bash /nfs/home/mholzinger/SOLR_regex/print_solr_core_properties.sh C36557"
```

**Example output:**

```
/var/solr/instance-1/C36557_content/core.properties:MASTER_CORE_URL=dummy
/var/solr/instance-1/C36557_attachments/core.properties:MASTER_CORE_URL=dummy
/var/solr/instance-1/C36557_hierarchy/core.properties:MASTER_CORE_URL=dummy
```

note: There are no other parameters to pass in, so leaving this argument as positional, ie: `<prog> <argument>`

---

### Edit hierarchy values

#### Command arguments:

`update_solr_instance_collect_hierarchy.sh`

```
 -c <collection>
 -m <define MASTER_CORE_SERVER= string>
 -p <port>
 -k <keepalive=TRUE>
```

Executing from a host directly:

All solr nodes should be able to see /nfs/mounted paths, with this assumption in place, running the script would be done on the solr VM target node.

in our example replicator node:

SSH to the node with changes needed on the /var/solr/instance-[1-99]/C12345_hierarchy/core.properties files.

Our script looks for between 1 and 99 instances of a collection.

**SSH to the target node**

```
ssh nd-012ff.solr.pdx.smarshinc.com
```

**Run the script file with a <master> <port> <collection> and <keepalive> parameter**

```
sudo /nfs/home/mholzinger/SOLR_regex/update_solr_instance_collect_hierarchy.sh -m nd-abcdef.smarshinc.com -p 8080 -c C12345 -k TRUE
```

Script output in this command example:

```
hostname:  nd-012ff.solr.pdx.smarshinc.com
service restarted [solr-01]
Collection = C12345
Master = nd-abcdef.smarshinc.com
Port = 8080
Keepalive (no restart) = TRUE
Current config file:
/var/solr/instance-1/C12345_hierarchy/core.properties:MASTER_CORE_URL=nd-67890.solr.pdx.smarshinc.com\:8080/solr/C12345_hierarchy
Files to change:
/var/solr/instance-1/C12345_hierarchy
Changed files:
/var/solr/instance-1/C12345_hierarchy/core.properties:MASTER_CORE_URL=nd-abcdef.smarshinc.com\:8080/solr/C7178_hierarchy
[solr-01] not restarted. Keepalive is set
Collection: C12345
Changed files:
/var/solr/instance-1/C12345_hierarchy/core.properties:MASTER_CORE_URL=nd-90012.smarshinc.com\:8080/solr/C12345_hierarchy
hostname:  nd-012ff.solr.pdx.smarshinc.com
service restarted [solr-01]
```
Note: I haven't omitted the output from keepalive that prints a restarted services list. Will add in the future. For now you get output from a service that will need to be restarted for changes to take effect.
