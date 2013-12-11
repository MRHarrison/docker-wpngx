#!/bin/sh

NAME=$(cat app.name)

MYSQL_LOCAL_FOLDER="/data/$NAME/mysql"
if [ ! -d "$MYSQL_LOCAL_FOLDER" ]; then
	mkdir -p $MYSQL_LOCAL_FOLDER
fi

WORDPRESS_LOCAL_FOLDER="/data/$NAME/uploads"
if [ ! -d "$WORDPRESS_LOCAL_FOLDER" ]; then
	mkdir -p $WORDPRESS_LOCAL_FOLDER
fi

TAG="sullof/wpngx:$NAME"

CONTAINER_ID=$(docker run -d -v $MYSQL_LOCAL_FOLDER:/var/lib/mysql:rw -v $WORDPRESS_LOCAL_FOLDER:/usr/share/nginx/www/wp-content/uploads:rw $TAG)

startie $NAME $CONTAINER_ID
