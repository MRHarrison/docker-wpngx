# docker-wordpress-nginx

A Dockerfile that installs the latest wordpress, nginx, php-apc and php-fpm. 

Compared with the original project -- [docker-worpress-nginx](https://github.com/eugeneware/docker-wordpress-nginx), by Eugene Ware -- 
this forked project starts from sullof/sshd -- [docker-sshd](https://github.com/sullof/docker-sshd) --
instead of ubuntu.

## Installation

```
$ git clone https://github.com/sullof/docker-wordpress-nginx.git
$ cd docker-wordpress-nginx
$ sudo docker build -t="docker-wordpress-nginx" .
```

## Usage

To spawn a new instance of wordpress:

```bash
$ sudo docker run -d docker-wordpress-nginx
```

You'll see an ID output like:
```
d404cc2fa27b
```

Use this ID to check the port it's on:
```bash
$ sudo docker port d404cc2fa27b 80 # Make sure to change the ID to yours!
```

This command returns the container ID, which you can use to find the external port you can use to access Wordpress from your host machine:

```
$ docker port <container-id> 80
```

You can the visit the following URL in a browser on your host machine to get started:

```
http://127.0.0.1:<port>
```

To connect to the container via ssh, run before 
```
docker run -t -i docker-wordpress-nginx cat /root/password.txt
```
You will see the current root's password.
