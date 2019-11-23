#!/usr/bin/env bash
#
#filepath: project/create-user.sh
#email: qyf1009@163.com
#author: qian1009
#usage: 自动批量创建多个用户


# 检测expect是否存在
rpm -q expect &> /dev/null 
if [ $? -eq 1 ];then
	yum -y install expect tcl tclx tcl-devel
fi

#用户输入所创建的用户数量
read -p "用户名： " username
read -p "密码： " passwd
read -p "批量创建的数量： " number
num=1
#创建用户
for num in $(seq 1 $number)
do
	useradd $username-$num
	/usr/bin/expect <<-EOF
	spawn passwd $username-$num
	expect "新的 密码："
	send "$passwd\r"
	expect "重新输入新的 密码："
	send "$passwd\r" 
	expect eof
	EOF
done


