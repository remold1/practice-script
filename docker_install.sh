#!/usr/bin/env bash
#
#author: remold1
#date: 2019/12/28
#usage: install docker


#Delete the old docker
delete() {
	sudo yum -y remove docker docker-client docker-client-latest docker-common docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine &>/dev/null 
}
#install docker
install() {
	sudo yum -y install epel-release yum-utils device-mapper-persistent-data lvm2 &> /dev/null
	sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo &> /dev/null
	sudo yum makecache fast &> /dev/null
	sudo yum -y install docker-ce &> /dev/null
	systemctl start docker
	systemctl enable docker &> /dev/null
}
#Configure docker image acceleration
accelerate() {
	touch /etc/docker/daemon.json
	cat > /etc/docker/daemon.json <<-EOF
	{
		"registry-mirrors": ["https://mb8n4btz.mirror.aliyuncs.com"]
	}   
	EOF
        sudo systemctl daemon-reload
	sudo systemctl restart docker
}

#Detect kernel version
a=`uname -a | awk '{print $3}' | awk -F. '{print $1}'`
b=`uname -a | awk '{print $3}' | awk -F. '{print $2}'`
c=`find / -name "$0"`
chmod +x $c
if [ $a -ge 3 -a $b -ge 10 ];then
	echo "Ready to install..."
	delete  
	install
	accelerate 
	echo "installation complete."
else
	echo "The kernel version is too low. Please upgrade the kernel..."
fi

