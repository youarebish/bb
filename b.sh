#!/bin/bash
#  create virsh computer
read -p "要创建的虚拟机名称:" a

if [ $? -eq 0 ];then
	echo 正确
else
	echo 错误
fi
