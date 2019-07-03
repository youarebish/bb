#!/bin/bash
VIP=192.168.4.15:80
RIP1=192.168.4.10
RIP2=192.168.4.20

MD5=`curl -s  http://192.168.4.10 |  md5sum | awk '{print $1}'`
MD8=`curl -s  http://192.168.4.20 |  md5sum | awk '{print $1}'`
#while :
#do
#   for IP in $RIP1
#   do
#        MD6=`curl -s  http://192.168.4.10 |  md5sum | awk '{print $1}'`
#if [ $MD5 = $MD6 ];then
#            ipvsadm -Ln |grep -q $IP || ipvsadm -a -t $VIP -r $IP
#        echo $RIP1"已添加"
##exit 1  
#        else
#             ipvsadm -Ln |grep -q $IP && ipvsadm -d -t $VIP -r $IP
#        echo $RIP1"已删除"
##exit 2  
#        fi
#   done 
#sleep 1 
#done

