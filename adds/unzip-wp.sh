#!/bin/bash
tar xzf /wordpress.tar.gz -C /usr/share/nginx
mv /usr/share/nginx/www/5* /usr/share/nginx/wordpress
rm -rf /usr/share/nginx/www
mv /usr/share/nginx/wordpress /usr/share/nginx/www
chown -R www-data:www-data /usr/share/nginx/www
rm /wordpress.tar.gz
