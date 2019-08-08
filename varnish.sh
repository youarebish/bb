#!/bin/bash
#部署varnish
yum -y install gcc readline-devel ncurses-devel pcre-devel python-docutils
useradd -s /sbin/nologin varnish
cd lnmp_soft/
tar -xf varnish-5.2.1.tar.gz -C /root
cd
cd varnish-5.2.1/
./configure
make && make install
cp etc/example.vcl /usr/local/etc/default.vcl
#加速服务器
sed -i "/host = 127.0.0.1/  s/host = 127.0.0.1/host =192.168.2.100/" /usr/local/etc/default.vcl
sed -i  "/port = 8080/  s/port = 8080/port = 80/" /usr/local/etc/default.vcl
#起服务
varnishd -f /usr/local/etc/default.vcl
