#!/bin/bash

sudo /sbin/service solr-01 status|grep -E 'solr_home|uptime'
