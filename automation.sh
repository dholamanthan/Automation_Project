#!/bin/bash

#Variable
name=Manthan
timestamp=$(date '+%d%m%Y-%H%M%S')
s3name=upgrad-manthan

#Update the system
sudo apt update -y

#Install apache2 if not exists
sudo apt install apache2 -y

#Make sure apache2 is running
service apache2 restart

#Make sure Apache2 is enable on start
systemctl enable apache2

echo "Files Zipped :" >> /tmp/copy-log.txt

#Tar all the Apache2 Logs
tar -czvf $name-httpd-logs-$timestamp.tar.gz /var/log/apache2/*.log >> /tmp/copy-log.txt

#Upload the TarBall to S3
mv $name-httpd-logs-$timestamp.tar.gz /tmp/ | aws s3 cp /tmp/$name-httpd-logs-$timestamp.tar.gz s3://$s3name/$name-httpd-logs-$timestamp.tar.gz
echo "Uploaded to S3 at :" `date` >> /tmp/copy-log.txt

filesize=$(ls -lh /tmp/$name-httpd-logs-$timestamp.tar.gz | awk '{print  $5}')

#Check if inventory.html exists if not create it
FILE=/var/www/html/inventory.html
if [ -f "$FILE" ]; then
    echo -e "<br />httpd-logs &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;" $timestamp "&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;tar&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;" $filesize >> /var/www/html/inventory.html
else
    echo "<html><strong>Log Type &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;Time Created &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;Type&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;Size</strong>" > /var/www/html/inventory.html
fi

#Add Cronjob to Root User for running the Script
CRONFILE=/etc/cron.d/automation
if [ -f "$CRONFILE" ]; then
        echo  "File Exists"
else
        echo "* * * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
fi

echo "Cron Job Added" >> /tmp/copy-log.txt

echo "========================================" >> /tmp/copy-log.txt
echo "" >> /tmp/copy-log.txt
