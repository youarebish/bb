#!/bin/bash
yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-headles
tar -xf lnmp_soft.tar.gz
cd lnmp_soft/
tar -xf apache-tomcat-8.0.30.tar.gz -C /root
cd
mv apache-tomcat-8.0.30 /usr/local/tomcat
/usr/local/tomcat/bin/startup.sh
