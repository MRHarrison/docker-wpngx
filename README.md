docker-wpngx
============

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
$ sudo docker port <container-id> 80
```

You can the visit the following URL in a browser on your host machine to get started:

```
http://127.0.0.1:<port>
```

To connect to the container via ssh, run before 
```
$ sudo docker run -t -i docker-wordpress-nginx bash
```
substitute the current /root/.ssh/authorized_keys file with your public key. After, without exiting from the container
open a new terminal and commit the container to a new image with a command like this:
```
$ sudo docker commit [id container] [yourname]/sshd-nginx-wordpress
```
and your image is ready to use.
 
