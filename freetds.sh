#! /bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================================
#   System Required:  CentOS / RedHat / Fedora 
#   Description:  auto back mysqldatabase
#   Author: Lurenjia <cn.lurenjian@gmial.com>
#   Intro:  http://lurenjian.org.cn Version=1.0
#===============================================================================================
clear
echo "#############################################################"
echo "# freetds Auto Install Script for CentOS / RedHat / Fedora"
echo "# Intro: http://lurenjian.org.cn Version=1.0" 
echo "#"
echo "# Author: Lurenjia <cn.lurenjian@gmial.com>"
echo "#"
echo "#############################################################"
echo ""
#禁用SELINUX
if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
fi
#时间配置准确
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
yum -y install ntp
ntpdate us.pool.ntp.org
hwclock -w
#安装环境要求
yum -y install wget gcc gcc-c++ make
#下载源码文件
cd /usr/local/src
wget http://www.ibiblio.org/pub/Linux/ALPHA/freetds/old/0.63/freetds-0.63.tar.gz
#解压源码文件
tar -zxvf freetds-0.63.tar.gz
rm -rf freetds-0.63.tar.gz
cd /usr/local/src/freetds-0.63/
#开始安装软件
if [ ! -d /usr/local/freetds ]; then
	./configure --prefix=/usr/local/freetds --enable-msdblib --with-tdsver=8.0
	make && make install
	clear
	echo "[global]" > /usr/local/freetds/etc/freetds.conf
	echo "   tds version = 7.0" >> /usr/local/freetds/etc/freetds.conf
	echo "   dump file = /tmp/freetds.log" >> /usr/local/freetds/etc/freetds.conf
	echo "   debug flags = 0xffff" >> /usr/local/freetds/etc/freetds.conf
	echo "   " >> /usr/local/freetds/etc/freetds.conf
	echo "   timeout = 10" >> /usr/local/freetds/etc/freetds.conf
	echo "   connect timeout = 10" >> /usr/local/freetds/etc/freetds.conf
	echo "   " >> /usr/local/freetds/etc/freetds.conf
	echo "   text size = 64512" >> /usr/local/freetds/etc/freetds.conf
	echo "   client charset = utf8" >> /usr/local/freetds/etc/freetds.conf
	echo "   " >> /usr/local/freetds/etc/freetds.conf
	echo "[lurenjia]" >> /usr/local/freetds/etc/freetds.conf
	echo "   host = 192.168.0.223" >> /usr/local/freetds/etc/freetds.conf
	echo "   port = 1433" >> /usr/local/freetds/etc/freetds.conf
	echo "   tds version = 7.0" >> /usr/local/freetds/etc/freetds.conf
	echo "   client charset = utf8" >> /usr/local/freetds/etc/freetds.conf
	ln -s /usr/local/freetds/bin/tsql /bin/
fi
echo "Successfully install Freetds!!"
