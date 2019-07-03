#!/bin/bash
#for i in 31
#do

expect << EOF
pawn ssh -o StrictHostKeyChecking=no 

expect "password:"    {send "123456\r"}
expect "$"            {send "poweroff\r"}
EOF
#if [ $? -eq 0 ];then
#echo "连接成功"
#else
#echo "连接失败"
#fi
#done
