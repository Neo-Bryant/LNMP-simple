#!/bin/bash
echo -e "\033[35mLNMP基本环境部署开始:\033[39m"
if [ ! -e /root/lnmp_soft.tar.gz ];then
    echo "/root/lnmp_soft.tar.gz缺失,请提前准备好文件再运行本脚本!"
    exit 22
fi

tar -xf /root/lnmp_soft.tar.gz && echo -e "0--------------\033[35m/root/lnmp_soft.tar.gz解压完成\033[39m"
yum -y install gcc openssl-devel pcre-devel &> /dev/null  && echo -e "1--------------\033[35mgcc,openssl-devel,pcre-devel安装成功\033[39m"
useradd -s /sbin/nologin nginx &> /dev/null 
tar -xf /root/lnmp_soft/nginx-1.12.2.tar.gz -C /root/lnmp_soft/
echo -e "2--------------\033[35mnginx-1.12.2.tar.gz解压完成\033[39m "

cd /root/lnmp_soft/nginx-1.12.2

./configure \
--user=nginx --group=nginx \
--with-http_ssl_module \
--with-http_stub_status_module &> /dev/null && echo -e "3--------------\033[35mnginx源码包配置成功\033[39m" || echo "nginx源码包配置失败,请修改脚本配置" 

make &> /dev/null && echo -e "4--------------\033[35mnginx源码编译成功\033[39m"  || echo "nginx源码编译失败,请修改脚本配置"
make install &> /dev/null && echo -e "5--------------\033[35mnginx源码安装成功\033[39m"  || echo "nginx源码安装失败,请修改脚本配置"

cd /root/lnmp_soft/
yum -y install  mariadb mariadb-server mariadb-devel &> /dev/null && echo -e "6--------------\033[35mMariadb,Mariadb-server数据库安装成功\033[39m"
yum -y install php php-fpm php-mysql &> /dev/null && echo -e "7--------------\033[35mphp,php-fpm,php-mysql安装成功\033[39m"

/usr/local/nginx/sbin/nginx -s stop &> /dev/null
/usr/local/nginx/sbin/nginx && echo -e "8--------------\033[35mNginx服务已启动\033[39m"
echo "/usr/local/nginx/sbin/nginx" >> /etc/rc.local && echo -e "9--------------\033[35m已配置Nginx开机自启\033[39m"
chmod +x /etc/rc.local 

systemctl start mariadb  && echo -e "10-------------\033[35mmariadb服务已启动\033[39m"
systemctl enable mariadb &> /dev/null && echo -e "11-------------\033[35m已配置mariadb开机自启\033[39m"

systemctl start php-fpm && echo -e "12-------------\033[35mphp-fpm服务已启动\033[39m"
systemctl enable php-fpm &> /dev/null && echo -e "13-------------\033[35m已配置php-fpm开机自启\033[39m"

ln -s /usr/local/nginx/sbin/nginx /sbin/ &> /dev/null && echo -e "10-------------\033[35mningx已创建软连接\033[39m"
echo -e "\033[35mLNMP基本环境部署完成\033[39m\n"

echo -e "\033[33m80端口开启状态:\033[39m"
netstat -anptul | grep :80
echo 
echo -e "\033[33m3306端口开启状态:\033[39m"
netstat -anptul | grep :3306
echo
echo -e "\033[33m9000端口开启状态:\033[39m"
netstat -anptul | grep :9000
echo
