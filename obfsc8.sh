#!/bin/bash
url() {
    local string="${1}"; local strlen=${#string}
	local encoded=""; local pos c o
    for (( pos=0;pos<strlen;pos++ )); do
        c=${string:$pos:1};case "$c" in
            [-_.~a-zA-Z0-9] ) o="${c}" ;;
            * ) printf -v o '%%%02x' "'$c"
        esac;encoded+="${o}"
    done;echo "${encoded}" 
}
xor(){
    local i
    for ((i=0;i<${#1};i++)); do
        printf \\"$(printf '%03o' $(( $(printf '%d' "'${1:$i:1}") ^ 31 )) )"
    done
}
pre="eval $'"; post="'"
mid=$(printf "%s%s" 'base64 -di<<<' "$(base64 -w0 <<< "$@")"|od -A n -t x1|\
    sed -e 's/[[:xdigit:]]\{2\}/\x&/g' -e 's/ //g' -e 's/\x/\\x/g'|tr -d '\n')
url "$(xor "$(echo -n "$pre$mid$post"|tr '\!-~' 'P-~\!-O'|rev)";printf "\n")"
