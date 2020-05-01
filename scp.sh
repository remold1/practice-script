#!/bin/bash

read -p "please input scp type(send/get): " st
read -p "please input source file path: " sfile_dir
read -p "please input target file store path: " tfile_dir
read -p "please input target host ip: " tip
read -p "please input target user: " tuser
read -p "please input target password: " tpasswd

send() {
/usr/bin/expect <<-EOF
spawn sudo scp -o StrictHostKeyChecking=no ${sfile_dir} ${tuser}@${tip}:${tfile_dir}
expect "${tuser}@${tip}'s password:"
send "${tpasswd}\r"
expect eof
EOF
}

get() {
/usr/bin/expect <<-EOF
spawn sudo scp -o StrictHostKeyChecking=no ${tuser}@${tip}:${tfile_dir}  ${sfile_dir}
expect "${tuser}@${tip}'s password:"
send "${tpasswd}\r"
expect eof
EOF
}

if [ ${st} -eq get ];then
        get
else
        send
fi
