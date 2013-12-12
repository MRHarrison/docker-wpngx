#!/bin/bash

# create a password for root, even if we don't need it, to improve the security
apt-get install -y pwgen
PWD=`pwgen -c -n -1 12`
echo "Random password: $PWD"
echo -e "$PWD\n$PWD" | passwd
apt-get remove -y pwgen


# configure wordpress

if [ ! -f /usr/share/nginx/www/wp-config.php ]; then
	WORDPRESS_DB="wordpress"
	WORDPRESS_PASSWORD=$(cat /wordpress-db-pw.txt)
	rm /wordpress-db-pw.txt
	
	sed -e "s/database_name_here/$WORDPRESS_DB/
	s/username_here/$WORDPRESS_DB/
	s/password_here/$WORDPRESS_PASSWORD/
	/'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'LOGGED_IN_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
	/'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" \
	/usr/share/nginx/www/wp-config-sample.php > /usr/share/nginx/www/wp-config.php

	# Download nginx helper plugin
	curl -O `curl -i -s http://wordpress.org/plugins/nginx-helper/ | egrep -o "http://downloads.wordpress.org/plugin/[^']+"`
	unzip nginx-helper.*.zip -d /usr/share/nginx/www/wp-content/plugins
	chown -R www-data:www-data /usr/share/nginx/www/wp-content/plugins/nginx-helper

	# Activate nginx plugin and set up pretty permalink structure once logged in
	cat << ENDL >> /usr/share/nginx/www/wp-config.php
\$plugins = get_option( 'active_plugins' );
if ( count( \$plugins ) === 0 ) {
	require_once(ABSPATH .'/wp-admin/includes/plugin.php');
	\$wp_rewrite->set_permalink_structure( '/%postname%/' );
	\$pluginsToActivate = array( 'nginx-helper/nginx-helper.php' );
	foreach ( \$pluginsToActivate as \$plugin ) {
		if ( !in_array( \$plugin, \$plugins ) ) {
			activate_plugin( '/usr/share/nginx/www/wp-content/plugins/' . \$plugin );
		}
	}
}
ENDL

	chown www-data:www-data /usr/share/nginx/www/wp-config.php
fi

# configure mysql for wordpress
 if [ ! -f /var/lib/mysql/ibdata1 ]; then
	mysql_install_db
	/usr/bin/mysqld_safe & 
	sleep 5s
	
	mysql -e "create database wordpress; \
		grant all privileges on wordpress.* to 'wordpress'@'localhost' \
		identified by '$WORDPRESS_PASSWORD'; \
		flush privileges"
		
	killall mysqld
 fi

# start all the services
/usr/local/bin/supervisord -n
