#!/usr/bin/env bash
#
#filepath: project/ban_ssh.sh
#email: qyf1009@163.com
#author: qian1009
#usage: 当连接服务器密码输入错误超过三次禁止登陆服务器


cat /var/log/secure | awk '/Failed/{print $(NF-3)}' | sort | uniq -c | awk '{print $1"="$2}' > /root/deny.txt

DEFA="3"

for i in `cat /root/deny.txt`
do
IP=`echo $i | awk -F= '{print $2}'`
NUM=`echo $i | awk -F= '{print $1}'`
	if [ $NUM -gt $DEFA ];then
		grep $IP /etc/hosts.deny > /dev/null
		if [ $? -ne 0 ];then
			echo "sshd:$IP" >> /etc/hosts.deny
		fi
	fi
done
