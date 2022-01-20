# SOLR regex commands in bash (or how to get out of trouble in a hurry)

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

**Executing from a host directly:**

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

---

# Do stuff now:

#### 1) Print Core collection detail:

```
 ssh -n -T nd-012ff.solr.pdx.smarshinc.com "sudo /bin/bash /nfs/home/mholzinger/SOLR_regex/print_solr_core_properties.sh C12345"
```

Variations: Just print hierarchy core.properties files

```
ssh -n -T nd-012ff.solr.pdx.smarshinc.com "sudo /bin/bash /nfs/home/mholzinger/SOLR_regex/print_solr_core_properties.sh C12345"|grep hierarchy| sort
```

#### 2) Edit MASTER_CORE_URL Hierarchy:

From any bastion server, run an ssh command to execute the command script remotely on the target.

One liner: (edit a copy of this command and paste into a terminal session with the appropriate values)

```
ssh -n -T \
  nd-012ff.solr.pdx.smarshinc.com \
  "sudo /nfs/home/mholzinger/SOLR_regex/update_solr_instance_collect_hierarchy.sh \
  -m nd-abcdef.smarshinc.com \
  -p 8080 \
  -c C12345 \
  -k false
```

Prerequisites:
- SSH access to bastion host such as `pit-sreutil-01.ost.smarshinc.com`
- SMARSHINC Active directory creds for logging into the solr vm's or ssh-agent + ssh-add

---

# Fancy stuff:

Take an input file with hostname url's and output a list of collections and hosts separately.

Input hostlist and output ssh friendly hosts

`split_host_list.sh`

Splits out hosts and collections into two tmp files to be used as inputs for for loops.

**Example:**

```
/split_host_list.sh solr_hosts_collection_urls.txt
```

Ingests a file with urls that looks like:

`solr_hosts_collection_urls.txt`

```
http://nd-f843.solr.pdx.smarshinc.com:8080/solr/old.html#/C1141_hierarchy/replication	invalid
http://nd-81010.smarshinc.com:8080/solr/old.html#/C1141_hierarchy/replication			invalid
http://nd-3b64.solr.pdx.smarshinc.com:8080/solr/old.html#/C1141_hierarchy/replication	invalid
http://nd-91004.smarshinc.com:8080/solr/old.html#/C1141_hierarchy/replication			invalid
http://nd-b817.solr.qcy.smarshinc.com:8080/solr/old.html#/C1141_hierarchy/replication	invalid
```

**Output:**

```
Hosts: [ /var/folders/x5/lxy_49r13klg216wj1xgrg_m0000gq/T/hosts_sorted.6owPwFsm ]

nd-3b64.solr.pdx.smarshinc.com
nd-81010.smarshinc.com
nd-91004.smarshinc.com
nd-b817.solr.qcy.smarshinc.com
nd-f843.solr.pdx.smarshinc.com
```

Using a clean hostlist in a for loop:

Run the HOSTLIST command printed from the split_host_list.sh script

```
HOSTLIST=/var/folders/x5/lxy_49r13klg216wj1xgrg_m0000gq/T/hosts_sorted.6owPwFsm
```

Next pass that into a for loop with the expected use parameters for the script

```
cat $HOSTLIST | while read -r solr_node;do ssh -n -T "$solr_node" "sudo  /nfs/home/mholzinger/SOLR_regex/update_solr_instance_collect_hierarchy.sh -m nd-abcdef.smarshinc.com -p 8080 -c C12345 -k TRUE";done
```
