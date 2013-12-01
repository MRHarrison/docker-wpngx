#!/bin/bash

PWD=`pwgen -c -n -1 12`
echo "Random password: $PWD"
echo -e "$PWD\n$PWD" | passwd
echo "$PWD" > /root/password.txt


