docker-wpngx
============

A Dockerfile that installs the latest wordpress, nginx, php-apc and php-fpm. 

# Requirements

### sullof/sshd

Compared with the original project -- [docker-worpress-nginx](https://github.com/eugeneware/docker-wordpress-nginx), by Eugene Ware -- 
this forked project starts ```FROM sullof/sshd```, so first off you must build the image sullof/sshd from [docker-sshd](https://github.com/sullof/docker-sshd).
Alternatively, you can edit ```Dockerfile``` and change it to ```FROM ubuntu:12.04``` and remove the port 22 from the ```EXPOSE``` command. 

### [Startie](https://github.com/sullof/startie) 

Startie is a simple bash script to recover the correct association between a local domain name and the IP of a container, 
for example after a server reboot. If you don't want to use it, remove last line from ```run.sh```.

# Installation

```
git clone https://github.com/sullof/docker-wpngx.git
cd docker-wpngx
sudo chmod +x *.sh
```
Change the name of your app in the file ```app.name```. In this example Startie handles a blog called colourmoves, managing the local domain name colourmoves.local.

# Usage

To build the image execute:

```bash
sudo ./build 
```

To run the new container, execute:
```
sudo ./run.sh
```
Consider that to mantain the persistence, ```run.sh``` associate some local folders to some container's folders. Specifically, in our case, it will
associate ```/data/colourmoves/mysql``` to ```/usr/lib/mysql``` and ```/data/colourmoves/uploads``` to ```/usr/share/nginx/www/wp-content/uploads```. This way
if the container restarts for some reason, your data will be safe.
Also, at the end of the script, ```run.sh``` calls Startie to save the configuration and associate the IP of the container to the local domain name colourmoves.local 
(or what you have set in the ```app.name``` file).
 
At the end you'll see an ID output like:
```
colourmoves.local has been associated with 172.14.0.8
```
Now, if you open your browser and run http://colourmoves.local you will see a new Wordpress installation page.
