#!/usr/bin/env bash
#
#email: qyf1009@163.com
#author: qian1009
#date: 2019/10/16 16:30
#usage: remove mysqld log 



#把mysqld.log日志中5月份之前的记录全部删掉
for i in {1..31}; do
{
	sed "/[^.]*${i}\/Jan\/2019[^.]*/d" $1
	sed "/[^.]*${i}\/Feb\/2019[^.]*/d" $1
	sed "/[^.]*${i}\/Mar\/2019[^.]*/d" $1
	sed "/[^.]*${i}\/Apr\/2019[^.]*/d" $1
}&
done
wait
echo "1~5 months remove finish.."

