FROM sullof/sshd
# for more info about this basic image:
# https://github.com/sullof/docker-sshd

MAINTAINER Francesco Sullo, <sullof@gmail.com>
# based on https://github.com/eugeneware/docker-wordpress-nginx

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update; apt-get -y upgrade

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -s /bin/true /sbin/initctl

# Basic Requirements
RUN apt-get -y install mysql-server mysql-client nginx php5-fpm php5-mysql php-apc pwgen curl git unzip

# Wordpress Requirements
RUN apt-get -y install php5-curl php5-gd php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl

# mysql config
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# nginx config
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
# since 'upload_max_filesize = 2M' in /etc/php5/fpm/php.ini
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 3m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm config
RUN sed -i -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN find /etc/php5/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# nginx site conf
ADD adds/nginx-site.conf /etc/nginx/sites-available/default

# Supervisor Config
# Consider that supervisord is installed and configured by sullof/sshd.
# We only need to append something to the existent file.
ADD adds/supervisord.conf /etc/supervisord.conf.tmp
RUN cat /etc/supervisord.conf.tmp >> /etc/supervisord.conf && rm /etc/supervisord.conf.tmp

# Install Wordpress
ADD http://wordpress.org/latest.tar.gz /wordpress.tar.gz
ADD adds/unzip-wp.sh /unzip-wp.sh
RUN bin/bash /unzip-wp.sh
RUN rm /unzip-wp.sh

# Wordpress Initialization and Startup Script
ADD adds/wordpress-db-pw.txt /wordpress-db-pw.txt
ADD adds/start.sh /start.sh
RUN chmod 755 /start.sh

# private expose
EXPOSE 80 22

CMD ["/start.sh"]
