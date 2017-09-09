#!/bin/bash
# scanner.sh - single-thread port scanner (TCP) written in bash
# Usage: . tcps; scan <host> <port, port-range>

# waits $1 amount of seconds before killing $2
alarm() {
    local timeout=$1; shift;
    # execute command, store PID
    bash -c "$@" &
    local pid=$!
    # sleep for $timeout seconds, then attempt to kill PID
    { sleep "$timeout" ; kill $pid 2> /dev/null } &
	wait $pid 2> /dev/null ; return $?
}

# write to /dev/tcp/$1/$2; if write is successful, port is open.
scan() {
    if [[ -z $1 || -z $2 ]]; then echo "Usage: scan <host> <port, port-range>"; return; fi

    local host=$1; local ports=()
    # store user-provided ports in array
    case $2 in
        *-*) IFS=- read -r start end <<< "$2"
             for ((port=start; port <= end; port++)); do
                 ports+=("$port")
             done ;;
        *,*) IFS=, read -ra ports <<< "$2" ;;
        *)   ports+=("$2") ;;
    esac

    # attempt to write to each port, print open if successful.
    for port in "${ports[@]}"; do
        alarm 1 "echo >/dev/tcp/$host/$port" && echo "$port/tcp open" || echo "$port/tcp closed"
    done
};
