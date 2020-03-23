#!/bin/bash

KEYWORD=$1
LOGFILE=$2
DATE=`date`

tail /var/log/httpd/access_log > /var/log/apache_log

if grep $KEYWORD $LOGFILE &> /dev/null
then
logger "$DATE: Access from the Internet Explorer"
else
exit 0
fi
