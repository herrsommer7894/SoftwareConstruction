#!/bin/bash
#file_sizes.sh

#prints names of files in curr dir and splits them into categories: small, medium-sized and large.

echo "Small files: " wc -l | cut -d' ' -f5,8 | sort -n | egrep "[0-9]" | cut -f8
echo "Medium-sized files: "
echo "Large files: "