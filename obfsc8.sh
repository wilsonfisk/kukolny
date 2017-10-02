#!/bin/bash
pre="eval $'"; post="'"
text=$(base64 -w0<<<"command-to-hide")
step1=$(echo -n "$pre";echo -n 'base64 -di <<<'"$text"|od -A n -t x1|sed -e 's/[[:xdigit:]]\{2\}/\x&/g' -e 's/ //g' -e 's/\x/\\x/g'|tr -d '\n';echo -n "$post")
step2=$(echo "$step1"|rev|tr '\!-~' 'P-~\!-O')
echo "$step2"

# Reverse process:
# tr 'P-~\!-O' '\!-~'
# rev
