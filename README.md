docker-wpngx
============

A Dockerfile that installs the latest wordpress, nginx, php-apc and php-fpm. 

# Requirements

### [docker-sshd](https://github.com/sullof/docker-sshd)

Compared with the original project -- [docker-worpress-nginx](https://github.com/eugeneware/docker-wordpress-nginx), by Eugene Ware -- 
this forked project starts ```FROM sullof/sshd```, so first off you must build the image sullof/sshd starting from 
[docker-sshd](https://github.com/sullof/docker-sshd). If you don't need an ssh connection, 
you can edit the ```Dockerfile```, change the first line to ```FROM ubuntu:12.04```, and remove the 
port 22 from the ```EXPOSE``` command. 

### [startie](https://github.com/sullof/startie) 

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

## License 

(The MIT License)

Copyright (c) 2013 Francesco Sullo <sullof@sullof.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.