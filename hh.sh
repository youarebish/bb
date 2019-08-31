#!/bin/bash
#  create virsh computer
read -p "要创建的虚拟机名称:" a

if [$? -eq 0 ];then

 

 virsh dumpxml rh7_node01 >  $a.xml


sed -i "s/rh7_node01/$a/" /etc/libvirt/qemu/$a.xml

sed -i "s/<uuid>1453cad8-8721-4b0c-b264-2ee3f51b5bc9</uuid>/<uuid>1453cad8-8721-4b0c-b264-2ee3f51b5$a</uuid>" /etc/libvirt/qemu/$a.xml

sed -i "/74/ s/52:54:00:33:57:09/52:54:00:33:57:$a" /etc/libvirt/qemu/$a.xml

virsh define /etc/libvirt/qemu/$a.xml

echo "虚拟机$a 创建成功"
fi
