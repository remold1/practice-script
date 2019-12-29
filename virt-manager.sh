#!/bin/bash
# 此为kvm虚拟机基本管理工具

work_dir=`pwd`
images_dir=/var/lib/libvirt/images
xml_dir=/etc/libvirt/qemu

red_col="\e[1;31m"
green_col="\e[1;32m" 
blue_col="\e[1;34m"  
dred_col="\e[1;35m"    #洋红
dgreen_col="\e[1;36m"  #青色
reset_col="\e[0m"

menu() {
cat <<-EOF

 + ————————————————————————————————————————————————————————————————————————— +
 |									      |
 |	===============================================================	      |
 |		  	虚拟机基本管理工具 v2.0				      |
 |		            		                 		      |
 |	===============================================================	      |
 |									      |
 |	 A. 安装kvm虚拟化组件virtual*	  L. 批量创建OpenSUSE42虚拟机	      |
 |	 B. 批量创建CentOS6u8虚拟机	  N. 批量创建ElementaryOS虚拟机	      |
 |	 C. 批量创建CentOS7u6虚拟机	  O. 自定义虚拟机IP及hostname	      |
 |	 D. 批量创建CentOS7u6x虚拟机	  P. 多机互信(推公钥)并获取IP	      |
 |	 E. 批量创建RedHat6u8虚拟机	  R. 批量创建Windows7虚拟机	      |
 |	 F. 批量创建RedHat7u3虚拟机	  S. 批量创建Windows10虚拟机	      |
 |	 G. 批量创建RedHat7u3x虚拟机	  T. 批量创建Windows2008虚拟机	      |
 |	 H. 批量创建Ubuntu1604虚拟机	  U. 批量创建Windows2016虚拟机	      |
 |	 I. 批量创建Ubuntu1604x虚拟机	  V. 解决(uid:107，gid:107)问题	      |
 |	 J. 批量创建LinuxMinit虚拟机	  W. 删除指定批次虚拟机		      |
 |	 K. 批量创建Kali2017虚拟机	  X. 删除所有虚拟机		      |
 |									      |
 + ————————————————————————————————————————————————————————————————————————— +  
EOF
}

# 检查当前用户是不是root用户
checkroot() {
	current_user=`whoami` &>/dev/null
	if [ ! $current_user = 'root' ];then
		-en "${red_col}运行此脚本将改变系统文件，需root用户权限；当前用户非root用户，请先运行“su - root”命令切换至root用户，然后再重新运行本程序！${reset_col}"
		break
	fi
}

# 复制qemu控制台桌面快捷方式及本虚拟机管理工具说明
copy_virt_manager_desktop() {
	cp -rf ${work_dir}/virt-manager.desktop /root/Desktop/virt-manager.desktop &>/dev/null
	cp -rf ${work_dir}/Readme /root/Desktop/Readme &>/dev/null
	chmod a+x /root/Desktop/virt-manager.desktop &>/dev/null

	cp -rf ${work_dir}/virt-manager.desktop /root/桌面/virt-manager.desktop  &>/dev/null
	cp -rf ${work_dir}/Readme /root/桌面/Readme  &>/dev/null
	chmod a+x /root/桌面/virt-manager.desktop &>/dev/null
}

# 批量创建虚拟机
system_install() {
	systemctl status libvirtd | grep "Active: active (running)" &>/dev/null
	if [ $? -ne 0 ];then
		echo -en "\n${red_col}本机尚未安装kvm虚拟化组件或尚未启动libvirtd服务，请先安装kvm虚拟化组件或启动libvirtd服务……${reset_col}\n"
		continue
	fi

	find ${work_dir}/${system_type}/ -maxdepth 1 | grep qcow2 &>/dev/null
	if [ $? -ne 0 ];then
		echo -en "\n${red_col}尚未准备所请求的${system_type}虚拟机镜像模板，请重新选择……${reset_col}\n"
		continue
	fi
	while :
	do
		echo -en "\n${green_col}请输入虚拟机应用于什么项目：${reset_col} " 
		read pro
		vm=${pro}-${system_type}

		echo -en "\n${green_col}请输入欲创建虚拟机的数量：${reset_col} " 
		read vm_num

		virsh list --all |awk '{print $2}'| grep '[a-z A-Z 0-9]' > /tmp/all_kvm.txt	
		a_vm=`cat /tmp/all_kvm.txt`
		if echo "${a_vm[@]}" | sed 's/, /\n/g' | grep "${vm}\>" &>/dev/null; then
			if [ ${vm_num} -gt 1 -a ${vm_num} -lt 10 ];then
				cat /tmp/all_kvm.txt | grep "${vm}\>" | grep "[\-][1-9]\>" > /tmp/d_kvm.txt
			elif [ ${vm_num} -gt 10 -a ${vm_num} -lt 99 ];then
				cat /tmp/all_kvm.txt | grep "${vm}\>" | grep "[0-9][0-9]\>" > /tmp/d_kvm.txt 
			else
				cat /tmp/all_kvm.txt | grep "${vm}\>" | grep "[0-9][0-9][0-9]\>" > /tmp/d_kvm.txt
			fi
			cat /tmp/d_kvm.txt
			echo -en "${red_col}本机已有上述${vm}虚拟机，确认重置它们吗? [继续：y|Y；退出请按其它任意键] ${reset_col}"
			read char
			if [ ${char} != y -a ${char} != Y ];then
				echo -en "\n${red_col}你选择了放弃重置上述${vm}虚拟机…… ${reset_col}\n"
				break
			fi
		fi

		echo -en "\n${green_col}请输入虚拟机的最小内存(单位M，最大内存4096M)：${reset_col} " 
		read mem

		echo -en "\n${green_col}请输入虚拟机的最小cpu个数(最大核心4核)：${reset_col} " 
		read vm_cpu

		for i in `seq -w $vm_num`		
		do
			vm_name=${vm}-${i}
			vm_mem=$[${mem}*1024]
			virsh destroy ${vm_name} &>/dev/null
			virsh undefine ${vm_name} &>/dev/null
			rm -rf ${xml_dir}/${vm_name}.xml 
			rm -rf ${images_dir}/${vm_name}.*

			vm_uuid=$(uuidgen)
			vm_mac="52:54:$(dd if=/dev/urandom count=1 2>/dev/null | md5sum | sed -r 's/^(..)(..)(..)(..).*$/\1:\2:\3:\4/')"
			img=${work_dir}/${system_type}/${system_type}.qcow2
			xml=${work_dir}/${system_type}/${system_type}.xml
			vm_img=${images_dir}/${vm_name}.qcow2
			vm_xml=${xml_dir}/${vm_name}.xml

			qemu-img create -f qcow2 -b ${img} ${vm_img} &>/dev/null			
			cp -rf ${xml} ${vm_xml} &>/dev/null

			sed -ri "s#vm_name#$vm_name#" ${xml_dir}/${vm_name}.xml
			sed -ri "s#vm_mem#$vm_mem#" ${xml_dir}/${vm_name}.xml
			sed -ri "s#vm_cpu#$vm_cpu#" ${xml_dir}/${vm_name}.xml
			sed -ri "s#vm_uuid#$vm_uuid#" ${xml_dir}/${vm_name}.xml
			sed -ri "s#vm_mac#$vm_mac#" ${xml_dir}/${vm_name}.xml
 			sed -ri "s#vm_img#$vm_img#" ${xml_dir}/${vm_name}.xml

        		virsh define ${xml_dir}/${vm_name}.xml &>/dev/null
			echo -en "\n虚拟机${vm_name}创建/重置完成......\n"
		done
		virsh list --all
		virt-manager

		echo -en "${red_col}应用于${pro}项目的${system_type}虚拟机已创建完成，要继续创建${system_type}虚拟机吗？[继续：y|Y；退出请按其它任意键]${reset_col}"
		read char
		if [ ${char} != y -a ${char} != Y ];then
			echo -en "\n${red_col}你选择了放弃继续创建${system_type}虚拟机……	\n${reset_col}"
			break
		fi
	done
}

# 检测本机是否存在虚拟机
vm_test(){
	virsh list --all |awk '{print $2}'| grep '[a-z A-Z 0-9]' > /tmp/all_kvm.txt
	if [[ `cat /tmp/all_kvm.txt |wc -l` -eq 0 ]];then
		echo -en "\n${red_col}本机尚未创建虚拟机，请重新选择……${reset_col}\n"
		continue
	fi
}

# 过滤本机已存在的与欲操作虚拟机同批次的虚拟机
vm_relation(){
	virsh list --all
	echo -en "${red_col}本机已有虚拟机如上表所示，请输入欲${operation}虚拟机中任意一个虚拟机的完整域名:  ${reset_col}" 
	read d_vm
	virsh list --all |awk '{print $2}'| grep '[a-z A-Z 0-9]' > /tmp/all_kvm.txt
	a_vm=`cat /tmp/all_kvm.txt`
	if echo "${a_vm[@]}" | sed 's/, /\n/g' | grep "^${d_vm}$" &>/dev/null; then
		keyword=`echo ${d_vm} |awk 'NF-=1' FS="-" OFS="-"`
		keywordtwo=`echo ${d_vm} |awk '{print $2}' FS="-" OFS="-"`
		if [ -z "$keyword" ]; then
			cat /tmp/all_kvm.txt | grep "${d_vm}\>" > /tmp/d_kvm.txt
			system_type=${d_vm}
		else
			LENTH=`echo ${d_vm} |awk -F- '{print $NF}'|awk '{print length($0)}'`
			if [ ${LENTH} -eq 1 ];then
				cat /tmp/all_kvm.txt | grep "${keyword}\>" | grep "[\-][1-9]\>" > /tmp/d_kvm.txt
			elif [ ${LENTH} -eq 2 ];then
				cat /tmp/all_kvm.txt | grep "${keyword}\>" | grep "[0-9][0-9]\>" > /tmp/d_kvm.txt 
			else
				cat /tmp/all_kvm.txt | grep "${keyword}\>" | grep "[0-9][0-9][0-9]\>" > /tmp/d_kvm.txt
			fi
			system_type=${keywordtwo}
		fi
		cat /tmp/d_kvm.txt
		echo -en "\n${red_col}所有与${d_vm}同批创建的虚拟机列表如上所示，确认${operation}吗？ [y|Y]: ${reset_col}"
		read char
		if [ ${char} != y -a ${char} != Y ];then
			echo -en "\n${red_col}你选择了放弃对${d_vm}以及与它同批创建的所有虚拟机${operation}操作…… ${reset_col} \n" 
			break
		fi
	else
		echo -en "\n${red_col}所请求的${d_vm}虚拟机并未被创建，请重新输入：  ${reset_col}"
		continue
	fi
}

menu
checkroot	
copy_virt_manager_desktop

while :
do
	echo -en "\n${green_col}请选择相应的操作(支持大小写)[A-X], 显示菜单[M|m],退出程序[Q|q]: ${reset_col}"
	read choose
	case $choose in 

# 安装kvm虚拟化组件
	A|a)
		menu
		copy_virt_manager_desktop
		systemctl status libvirtd | grep "Active: active (running)" &>/dev/null
		if [ $? -eq 0 ];then
			echo -en "\n${red_col}本机已安装过kvm虚拟化组件，不必再安装啦！\n${reset_col}"
			continue
		else
			echo -e "\n 开始安装kvm虚拟化组件……\n"
			yum -y groupinstall "virtual*" &>/dev/null
			yum –y install qemu-kvm libvirt virt-install bridge-utils virt-manager &>/dev/null
			yum -y install libguestfs-tools libguestfs-tools-c &>/dev/null
			echo -en "\nkvm虚拟化组件已安装完成……\n"
		fi
		;;

# 批量创建CentOS6u8虚拟机
	B|b)
		system_type=CentOS6u8
		system_install
		;;

# 批量创建CentOS7u6虚拟机
	C|c)
		system_type=CentOS7u6
		system_install
		;;

# 批量创建CentOS7u6x虚拟机(带桌面)
	D|d)
		system_type=CentOS7u6x
		system_install
		;;

# 批量创建RedHat6u8虚拟机
	E|e)
		system_type=RedHat6u8
		system_install
		;;

# 批量创建RedHat7u3虚拟机
	F|f)
		system_type=RedHat7u3
		system_install
		;;

# 批量创建RedHat7u3x虚拟机(带桌面)
	G|g)
		system_type=RedHat7u3x
		system_install
		;;

# 批量创建Ubuntu1604虚拟机
	H|h)
		system_type=Ubuntu1604
		system_install
		;;

# 批量创建Ubuntu1604虚拟机(桌面版)
	I|i)
		system_type=Ubuntu1604x
		system_install
		;;

# 批量创建LinuxMinit虚拟机
	J|j)
		system_type=LinuxMinit
		system_install
		;;

# 批量创建Kali2017虚拟机
	K|k)
		system_type=Kali2017
		system_install
		;;

# 批量创建OpenSUSE42虚拟机
	L|l)
		system_type=OpenSUSE42
		system_install
		;;

# 批量创建ElementaryOS虚拟机
	N|n)
		system_type=ElementaryOS
		system_install
		;;

# 自定义虚拟机IP、主机名(限Linux虚拟机)
	O|o)
		menu
		operation=自定义IP和主机名
		vm_relation
		echo -en "\n${red_col}请输入欲自定义的虚拟机数量：  ${reset_col}" 
		read vm_num
		echo -en "\n${red_col}请输入主机名：  ${reset_col}"
		read vhostname

		echo -en "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4\n::1         localhost localhost.localdomain localhost6 localhost6.localdomain6\n" > /etc/hosts
		out=`rpm -qa libguestfs-tools`
		if [ ! $out ]; then
			yum -y install libguestfs-tools libguestfs-tools-c &>/dev/null
		else
			if [ ! -d /mnt/${system_type} ]; then
				mkdir /mnt/${system_type}
			fi
			for i in `seq -w $vm_num`
			do
				vm_numth=$( cat /tmp/d_kvm.txt | sed -n ${i}p)
				guestmount -a ${images_dir}/${vm_numth}.qcow2 -i --rw /mnt/${system_type}
				a=`expr ${i} + 0`
				j=$[${a}+1]
				vm_ip=192.168.122.${j}
				echo -en "${vhostname}${i}\n" > /mnt/${system_type}/etc/hostname	#CentOS7改主机名
				echo -en "NETWORKING=yes\nHOSTNAME=${vhostname}${i}\n" > /mnt/${system_type}/etc/sysconfig/network	#CentOS6改主机名
				echo -en "NAME=eth0\nDEVICE=eth0\nONBOOT=yes\nTYPE=Ethernet\nNM_CONTROLLED=no\nBOOTPROTO=none\nIPADDR=${vm_ip}\nPREFIX=24\nGATEWAY=192.168.122.1\nDNS1=114.114.114.114\nDNS2=202.106.0.20\n" > /mnt/${system_type}/etc/sysconfig/network-scripts/ifcfg-eth0 
				echo -en "${vm_ip} ${vhostname}${i}.${system_type}.com ${vhostname}${i}\n" >> /etc/hosts
				umount /mnt/${system_type}
			done
			rm -rf /mnt/${system_type}

			for i in `seq -w $vm_num`
			do
				vm_numth=$( cat /tmp/d_kvm.txt | sed -n ${i}p)
				virt-copy-in -a ${images_dir}/${vm_numth}.qcow2 /etc/hosts /etc/
			done
		fi

		ip_forward=`cat /proc/sys/net/ipv4/ip_forward`
		if [ ${ip_forward} -ne 1 ];then
			echo 1 > /proc/sys/net/ipv4/ip_forward	# 临时开启路由转发
			echo net.ipv4.ip_forward = 1 >> /etc/sysctl.conf	# 永久开启路由转发
		fi

		menu
		echo -en "\n${green_col} 所请求的${system_type}虚拟机已配置完成，本机现有虚拟机列表如下： ${reset_col} \n"
		virsh list --all
		;;

# 多机互信(推公钥)并获取IP(限Linux虚拟机)
	P|p)
		virsh list --all
		echo -en "\n${red_col}本机已有虚拟机如上所示，请先手动启动虚拟机，并耐心等待所选择的虚拟机启动完成…… ${reset_col}"
		virt-manager
		sleep 5

		rpm -q expect &>/dev/null
		if [ $? -ne 0 ];then
			yum -y install expect &>/dev/null
		fi

		if [ ! -f ~/.ssh/id_rsa.pub ];then
			ssh-keygen -t rsa -f /root/.ssh/id_rsa -P ''
			rm -rf /root/.ssh/known_hosts &>/dev/null
			cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
		fi

		> /tmp/ip.txt

		vm_num=`virsh list --all |grep running |wc -l`
		for i in {2..254}
		do
		{
			ip=192.168.122.$i
			ping -c1 $ip &>/dev/null
			if [ $? -eq 0 ];then
				echo $ip >> /tmp/ip.txt
				/usr/bin/expect <<-EOF
				set timeout 10
				spawn scp -r /root/.ssh $ip:/root
				expect {
					"yes/no" { send "yes\r"; exp_continue }
					"password:" { send "centos\r"}
					}
				expect eof 
				EOF
			fi &>/dev/null
		}&
		done
		wait
		echo -en "\n${blue_col}公钥已推送完成，并获取虚拟机IP如下：${reset_col} \n"
		cat /tmp/ip.txt
		;;

# 批量创建创建Windows7虚拟机
	R|r)
		system_type=Windows7
		system_install
		;;

# 批量创建Windows10虚拟机
	S|s)
		system_type=Windows10
		system_install
		;;

# 批量创建Windows2008虚拟机
	T|t)
		system_type=Windows2008
		system_install
		;;

# 批量创建Windows2016虚拟机
	U|u)
		system_type=Windows2016
		system_install
		;;

# 解决(as uid:107，gid:107)权限问题
	V|v)
		vm_test
		cat /etc/libvirt/qemu.conf |grep ^'#user = "root"'
		if [ $? -eq 0 ];then
			sed -ri '/#vnc_listen = "0.0.0.0"/s/#//g' /etc/libvirt/qemu.conf
			sed -ri '/#user = "root"/s/#//g' /etc/libvirt/qemu.conf
			sed -ri '/#group = "root"/s/#//g' /etc/libvirt/qemu.conf
			sed -ri '/^#dynamic_ownership/c\dynamic_ownership = 0' /etc/libvirt/qemu.conf
			systemctl restart libvirtd &>/dev/null
			systemctl enable libvirtd &>/dev/null
		fi
		cat /etc/selinux/config |grep ^'SELINUX=disabled'
		if [ $? -ne 0 ];then
			sed '/^SELINUX=/c\SELINUX=disabled' /etc/selinux/config &>/dev/null
			setenforce 0 &>/dev/null
		fi
		echo -en "\n${blue_col} …… (as uid:107, gid:107) permission denied 问题已解决 ……${reset_col} \n"
		;;

# 批量删除指定批次虚拟机
	W|w)
		menu
		operation=批量删除它们
		while :
		do
			vm_relation
			vm_num=`cat /tmp/d_kvm.txt|wc -l`
			for i in `seq ${vm_num}`
			do
				vm_numth=$( cat /tmp/d_kvm.txt | sed -n ${i}p)   # 删除第i行
				virsh destroy "${vm_numth}" &>/dev/null
				virsh undefine "${vm_numth}" &>/dev/null
				rm -rf ${xml_dir}/${vm_numth}.xml
				rm -rf ${images_dir}/${vm_numth}.qcow2
			done

			rm -rf /tmp/kvm.txt
			virsh list --all
			echo -en "${red_col}已删除与${d_vm}同批次创建的所有虚拟机；要继续删除其它虚拟机吗？ [继续：y|Y；退出请按其它任意键]${reset_col} " 
			read char
			if [ ${char} != y -a ${char} != Y ];then
				echo -en "\n${red_col}你选择了放弃继续删除虚拟机…… ${reset_col} "
				break
			fi
		done
		;;

# 删除所有虚拟机
	X|x)
		menu
		vm_test
		echo -en "\n${red_col}确定删除所有虚拟机吗?  [y|Y]:${reset_col} " 
		read char
		if [ ${char} != y -a ${char} != Y ];then
			echo -en "\n${red_col}你选择了放弃删除所有虚拟机…… ${reset_col}\n"
			break					
		fi

		vnum=$(virsh list --all |awk '{print $2}'|grep '[a-z A-Z 0-9]'|wc -l)
		virsh list --all > /tmp/all_kvm.txt
		for i in `seq $vnum`
		do
			vnumth=$( cat /tmp/all_kvm.txt |awk '{print $2}'|grep '[a-z A-Z 0-9]'|sed -n ${i}p)
			virsh destroy "${vnumth}" &>/dev/null
			virsh undefine "${vnumth}" &>/dev/null
			rm -rf ${xml_dir}/${vnumth}.xml
			rm -rf ${images_dir}/${vnumth}.qcow2
		done
		rm -rf /tmp/all_kvm.txt
		echo -en "\n${red_col}哈哈哈，如你所愿，已经删除所有虚拟机啦啦啦…… ${reset_col} \n " 
		virsh list --all
		;;

	M|m)
		menu
		;;

	Q|q)
		exit
		;;

	*)
		echo -en "\n${red_col} 输入错误！！ ${reset_col} \n\n" 		
	esac
done

