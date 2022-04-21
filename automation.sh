#!/bin/bash

name=Manthan
timestamp=$(date '+%d%m%Y-%H%M%S') 
s3name=upgrad-manthan
sudo apt update -y
sudo apt install apache2 -y
service apache2 restart
systemctl enable apache2
tar -czvf $name-httpd-logs-$timestamp.tar.gz /var/log/apache2/*.log
mv $name-httpd-logs-$timestamp.tar.gz /tmp/ | aws s3 cp /tmp/$name-httpd-logs-$timestamp.tar.gz s3://$s3name/$name-httpd-logs-$timestamp.tar.gz
