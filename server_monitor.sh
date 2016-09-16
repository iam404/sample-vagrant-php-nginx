#!/bin/bash

# Configure Variables
SERVER2IP=192.168.33.124

while true
do
# Check Server1 Become A Live
nc -vz $SERVER2IP 80 &> /dev/null
if [ $? -ne 0 ]
then
 echo "Nginx is Down" | mail -s "Nginx is Down on remote server 192.168.33.24" example@localtest.me
 while $i
 do
  sleep 3
  nc -vz $SERVER2IP 80 &> /dev/null
  if [ $? -eq 0 ]
  then
  echo "Nginx is up" | mail -s "Nginx is UP again on remote server 192.168.33.24" example@localtest.me
   i=0
  fi
 done
fi
done
