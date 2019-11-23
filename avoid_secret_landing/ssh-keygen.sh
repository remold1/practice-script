#!/usr/bin/env bash
#
#filepath: project/ssh-keygen.sh
#author: qian1009
#email: qyf1009@163.com
#usage: 实现免密登陆

rpm -q expect &> /dev/null
if [ $? -eq 1 ];then
    yum -y install expect tcl tclx tcl-devel
fi
sshcopy(){
if [ ! -f /root/.ssh/id_rsa ];then
    ssh-keygen -P "" -f ~/.ssh/id_rsa >> /dev/null
fi

/usr/bin/expect <<-EOF
        set timeout 30
        spawn ssh-copy-id homework@192.168.222.138
        expect {
                "yes/no" { send "yes\r";exp_continue }
                "password:" { send "1\r" }
        }
        expect eof
EOF

}

ip="192.168.222.138"
if [ ! -f /root/.ssh/known_hosts ];then
        sshcopy
fi
grep "^$ip" /root/.ssh/known_hosts >/dev/null
if [ ! $? -eq 0 ];then
        sshcopy
fi

