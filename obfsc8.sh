#!/bin/bash
xor(){
    local i
    for ((i=0;i<${#1};i++));
        do printf \\"$(printf '%03o' $(( $(printf '%d' "'${1:$i:1}") ^ 31 )) )";
    done; printf "\n"
}
pre="eval $'"; post="'"
mid=$(printf "%s%s" 'base64 -di<<<' "$(base64 -w0 <<< $@)"|od -A n -t x1|\
    sed -e 's/[[:xdigit:]]\{2\}/\x&/g' -e 's/ //g' -e 's/\x/\\x/g'|\
    tr -d '\n')
xor "$(echo -n "$pre$mid$post"|tr '\!-~' 'P-~\!-O'|rev)"
printf '\n'
