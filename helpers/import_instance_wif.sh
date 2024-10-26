#!/bin/bash
for i in `ls -d instance-1*` ; do cd $i ; ./this_node_import_wif.cmd ; cd .. ; done
