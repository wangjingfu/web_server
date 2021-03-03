FROM centos:7.2.1511

MAINTAINER jingfu.wang@aliyun.com

RUN yum clean all && yum install -y vim tar wget curl rsync bzip2 iptables tcpdump less telnet net-tools lsof sysstat cronie python-setuptools

# 安装nginx
RUN yum install libxslt-devel -y gd gd-devel GeoIP GeoIP-devel pcre pcre-devel libxml2 libxml2-dev libxslt-devel gcc gcc++ \
 	&& rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm \
 	&& yum install -y nginx \
 	&& groupadd www-data \
 	&& useradd -M -s /sbin/nologin www-data -g www-data \
 	&& mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak \
 	&& mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak

COPY data/nginx/nginx.conf /etc/nginx/nginx.conf
COPY data/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# 安装PHP
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm \
 	&& yum -y install php72w php72w-cli php72w-common php72w-devel php72w-embedded php72w-fpm php72w-gd php72w-mbstring php72w-mysqlnd php72w-opcache php72w-pdo php72w-xml php-redis \
 	&& chmod -R 0777 /var/lib/php \
 	&& mv /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.bak

COPY data/php-fpm/www.conf /etc/php-fpm.d/www.conf

# 安装Redis
RUN yum install -y redis

COPY data/redis/conf/redis.conf /etc/redis/redis.conf

COPY shell/start.sh /root/start.sh

RUN yum -y install dos2unix* && dos2unix /root/start.sh

EXPOSE 80
EXPOSE 6379
EXPOSE 60379

CMD ["bash", "/root/start.sh"]