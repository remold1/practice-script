#!usr/bin/env bash
#
#filepath: project/Check_website_survival.sh
#email: qyf1009@163.com
#author: qian1009
#date: 2019/10/14 19:01
#usage: 检测网站的存活性


URLLIST=$(egrep "com|cn" ./url.txt)
for url in ${URLLIST}; do
  statuCode=$(curl -I --connect-timeout 3 -m 10 -s ${url} | grep "HTTP")
  if [[ ${statuCode: 9: 3} -eq 200 ]] || [[ ${statuCode: 9: 3} -eq 302 ]];then
	echo "$(date +'%Y-%m-%d %H:%M:%S') -run monitor program ${url} is ok" >>/var/log/urlMonitor.log
  else 
	echo "$(date +'%Y-%m-%d %H:%M:%S') - run monitor program ${url} is failed" >>/var/log/urlMonitor.log
	echo "[ERROR] ${url} Downtime! Please repair." 
  fi
done
