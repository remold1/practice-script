function Bond_V7()
{
clear
echo "========Add Bond Use eth0========"
cat /etc/sysconfig/network-scripts/ifcfg-eth[0-1]

echo -n  -e "\033[31m  Are you sure CentOS7 bonding the eth0 and eth1 (Y/N): \033[0m"
CHOOSE=y
if [ $CHOOSE = "y" ] || [ $CHOOSE = "Y" ] ;then
NET_DIR=/etc/sysconfig/network-scripts/
TIME=$(date "+%Y-%m-%d_%H:%M:%S")
mkdir -p /tmp/guangyan/

#CP IFCONFIG FILES
if [ ! -f ${NET_DIR}/ifcfg-bond0 ];then
cp ${NET_DIR}/ifcfg-eth0 ${NET_DIR}/ifcfg-bond0
fi

sed -i '1s/eth0/bond0/' ${NET_DIR}/ifcfg-bond0
sed -i '/HWADDR/d' ${NET_DIR}/ifcfg-bond0
sed -i '/UUID/d' ${NET_DIR}/ifcfg-bond0
sed -i '/BONDING_/d' ${NET_DIR}/ifcfg-bond0
echo 'BONDING_MASTER=yes' >> ${NET_DIR}/ifcfg-bond0
echo 'BONDING_OPTS="miimon=1 mode=balance-rr use_carrier=1"' >> ${NET_DIR}/ifcfg-bond0

sed -i.$TIME.bk '/IPADDR/d' ${NET_DIR}/ifcfg-eth0
sed -i 's/ONBOOT=no/ONBOOT=yes/' ${NET_DIR}/ifcfg-eth0
sed -i '/BOOTPROTO/d' ${NET_DIR}/ifcfg-eth0
echo "BOOTPROTO=none" >> ${NET_DIR}/ifcfg-eth0
sed -i '/NETMASK/d' ${NET_DIR}/ifcfg-eth0
sed -i '/IPADDR/d' ${NET_DIR}/ifcfg-eth0
sed -i '/GATEWAY/d' ${NET_DIR}/ifcfg-eth0

sed -i.$TIME.bk '/IPADDR/d' ${NET_DIR}/ifcfg-eth1
sed -i '/NETMASK/d' ${NET_DIR}/ifcfg-eth1
sed -i '/IPADDR/d' ${NET_DIR}/ifcfg-eth1
sed -i '/GATEWAY/d' ${NET_DIR}/ifcfg-eth1
sed -i 's/ONBOOT=no/ONBOOT=yes/' ${NET_DIR}/ifcfg-eth1
sed -i '/BOOTPROTO/d' ${NET_DIR}/ifcfg-eth1
echo "BOOTPROTO=none" >> ${NET_DIR}/ifcfg-eth1

mv ${NET_DIR}/ifcfg-eth*.bk /tmp/guangyan/

cat > ${NET_DIR}/ifcfg-bond-slave-eth0 <<EOF
TYPE=Ethernet
NAME=bond-slave-eth0
DEVICE=eth0
ONBOOT=yes
MASTER=bond0
SLAVE=yes
EOF

cat > ${NET_DIR}/ifcfg-bond-slave-eth1 << EOF
TYPE=Ethernet
NAME=bond-slave-eth1
DEVICE=eth1
ONBOOT=yes
MASTER=bond0
SLAVE=yes
EOF

sed -i '/N\/A/d' /etc/rc3.d/S27route
sed -i '/N\/A/d' /etc/sysconfig/static-routes

else
echo -e "\033[31m Not Add Bond \033[0m"
fi
}
Bond_V7

题目；网站访问不到
开始。如果通了



从本地ping服务器--->1 ping通 
				--->2 ping不通

A意味着网络OK (交换机)
B服务器系统（包含路由，IP）ok
C 尝试SSH登陆----> 1 能登陆
			 ----> 2 不能登陆
 a1 ssh登陆服务器查看服务及端口占
 用情况
 a2  远程管理卡登陆或者机房现场登陆
 都需要ROOT密码，如果没有需要破解
 登陆机器后，【查看ssh服务（重启），让
 我们能够正常登陆机器】

 二  ping不通
现场登陆或管理卡登陆
登陆后
1 ifconfig | grep "inet" 查看Ip地址
b1 有IP地址->ping 网关---c1 ping 
网关通了-->意味着网络OK-->一定是
路由的问题
c2 ping 网关不通-->查看网口（网线）
连接关系及交换机硬件及交换机端口
问题
b2 没有IP地址 
--网线是否插了 使用ethtool eth0
-查看及修改网卡配置文件并重启网络
服务--->网卡起不来(以外接网卡最多)
外接网卡查看驱动。
管理卡日志是在网页上查看。

如果服务器硬件有问题，系统
无法登陆了。 怎么判断硬件有问题
a1--电源故障及Pdu故障
a1.1 单电故障 a1.2 双电故障 
a1.1 通过管理卡日志，PSU1 error
a1.2 双电故障，只能现场查看灯灭了
插电，通电后无反应--不排除主板故障

a2--非电源故障
开机自检，管理卡日志 及外观去判断
断

222
111


222
222

111
111




www.qianfeng.com 

    LVS

                   80
server1        server2
s1 stop           2
































