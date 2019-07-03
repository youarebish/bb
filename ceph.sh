#!/bin/bash
ssh-keygen -f /root/.ssh/id_rsa -N ''
for i in 10 11 12 13
do
ssh-copy-id 192.168.4.$i
done

#域名
echo "192.168.4.10 client
192.168.4.11  node1
192.168.4.12  node2
192.168.4.13  node3" >> /etc/hosts
for i in 10 11 12 13
do
scp /etc/hosts 192.168.4.$i:/etc/
done

#yum源
echo "[mon]
name=mon
baseurl=ftp://192.168.4.254/ceph/MON
gpgcheck=0
[osd]
name=osd
baseurl=ftp://192.168.4.254/ceph/OSD
gpgcheck=0
[tools]
name=tools
baseurl=ftp://192.168.4.254/ceph/Tools
gpgcheck=0" >> /etc/yum.repos.d/local.repo
yum clean all
for i in 10 11 12 13
do
scp /etc/yum.repos.d/local.repo 192.168.4.$i:/etc/yum.repos.d/
done

#时间同步
echo "server 192.168.4.254 iburst" >> /etc/chrony.conf
for i in 10 11 12 13
do
scp /etc/chrony.conf 192.168.4.$i:/etc/
ssh 192.168.4.$i "systemctl restart chronyd"
done

#安装软件
yum -y install ceph-deploy
mkdir lo
cd lo

#部署ceph集群
ceph-deploy new node1 node2 node3
for i in node1 node2 node3
do
ssh $i "yum -y install ceph-mon ceph-osd ceph-mds ceph-radosgw"
done

#初始化所有节点
ceph-deploy mon create-initial

#创建OSD
for i in node1 node2 node3
do
ssh $i "parted /dev/vdb mklabel gpt"
ssh $i "parted /dev/vdb mkpart primary 1 50%"
ssh $i "parted /dev/vdb mkpart primary 50% 100%"
done

for i in node1 node2 node3
do
ssh $i chown ceph:ceph /dev/vdb1
ssh $i chown ceph:ceph /dev/vdb2
ssh $i echo 'ENV{DEVNAME}=="/dev/vdb1",OWNER="ceph",GROUP="ceph"' >> /etc/udev/rules.d/op.rules
ssh $i echo 'ENV{DEVNAME}=="/dev/vdb2",OWNER="ceph",GROUP="ceph"' >> /etc/udev/rules.d/op.rules
done

#初始化清空磁盘空间
ceph-deploy disk zap node1:vdc  node1:vdd
ceph-deploy disk zap node2:vdc  node2:vdd
ceph-deploy disk zap node3:vdc  node3:vdd

#创建OSD存储空间
ceph-deploy osd create node1:vdc:/dev/vdb1 node1:vdd:/dev/vdb2
ceph-deploy osd create node2:vdc:/dev/vdb1 node2:vdd:/dev/vdb2
ceph-deploy osd create node3:vdc:/dev/vdb1 node3:vdd:/dev/vdb2

#创建镜像
rbd create demo-image --image-feature layering --size 20G
rbd create rbd/image --image-feature  layering --size 20G

#扩容容量
rbd resize --size 30G image
ssh -X root@192.168.4.10
yum -y install ceph-common
scp 192.168.4.11:/etc/ceph/ceph.conf /etc/ceph/
scp 192.168.4.11:/etc/ceph/ceph.client.admin.keyring /etc/ceph
rbd map image
ebd showmapped
mkfs.xfs /dev/rbd0
mount /dev/rbd /mnt/
echo "test" > /mnt/test.txt
