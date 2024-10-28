#!/bin/bash

lif=$1
dme=$2
grep -f <(cat $lif) <( cut -f 1,`grep -n -f <(cat $lif) <( head -n1 $dme |tr '\t' '\n')|sed -e "s/:.*//g"|tr '\n' ','|sed -e "s/,$//"` $dme )

