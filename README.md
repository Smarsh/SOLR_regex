# SOLR_regex
SOLR Regex Patterns for in bash

Calling to print out properties with `print_solr_core_properties`

```
 ssh -n -T nd-91005.smarshinc.com "sudo /bin/bash /nfs/home/mholzinger/print_solr_core_properties.sh C36557"
```

Example output:

```
/var/solr/instance-1/C36557_content/core.properties:MASTER_CORE_URL=dummy
/var/solr/instance-1/C36557_attachments/core.properties:MASTER_CORE_URL=dummy
/var/solr/instance-1/C36557_hierarchy/core.properties:MASTER_CORE_URL=dummy
```

---

Calling to edit hierachy values

With ssh on a bastion to a remote host:

```
ssh -n -T nd-91005.smarshinc.com "sudo /bin/bash /nfs/home/mholzinger/update_solr_instance_collect_hierarchy.sh -c C34726 -m nd-80013.smarshinc.com -d nd-8655.solr.pdx.smarshinc.com"
```

Command arguments:

update_solr_instance_collect_hierarchy.sh
-c <collection>
-m <define master server>
-d <dead master server to replace>
-k <keepalive=TRUE>  (optional argument to prevent from restarting solr instance after updating config)
