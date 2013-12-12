#!/bin/sh

. ./docker-wpngx.conf

IMAGE="$REPOSITORY:$TAG"

MYSQL_LOCAL_FOLDER="/data/$TAG/mysql"
if [ ! -d "$MYSQL_LOCAL_FOLDER" ]; then
	mkdir -p $MYSQL_LOCAL_FOLDER
fi

WORDPRESS_LOCAL_FOLDER="/data/$TAG/uploads"
if [ ! -d "$WORDPRESS_LOCAL_FOLDER" ]; then
	mkdir -p $WORDPRESS_LOCAL_FOLDER
fi

CONTAINER_ID=$(docker run -d \
	-v $MYSQL_LOCAL_FOLDER:/var/lib/mysql:rw \
	-v $WORDPRESS_LOCAL_FOLDER:/usr/share/nginx/www/wp-content/uploads:rw \
	$IMAGE)

startie $TAG $CONTAINER_ID
