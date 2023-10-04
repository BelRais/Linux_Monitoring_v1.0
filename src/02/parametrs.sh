#!/bin/bash

echo "HOSTNAME = $HOSTNAME"
echo "TIMEZONE = $(cat /etc/timezone)"
echo "USER = $USER"
echo "OS = $(lsb_release -d | awk -F '\t' '{print $2}')"
echo "DATE = $(date +'%d %B %Y %X')" #data -- help
echo "UPTIME = $(uptime -p)"
echo "UPTIME_SEC = $(uptime -p | awk '/^up / {print ($2*60+$4)*60}')"
echo "$(ifconfig | awk '/inet / {mask_count++; print "IP_" mask_count " = " $2}')"
echo "$(ifconfig | awk '/netmask/ {mask_count++; print "MASK_" mask_count " = " $4}')"
echo "GATEWAY = $(ip route | awk '/default via / {print $3}')"
echo "RAM_TOTAL = $(free | awk '/^Mem:/||/^Память:/ {printf("%.3f GB", $2/1024/1024)}')"
echo "RAM_USED = $(free | awk '/^Mem:/||/^Память:/ {printf("%.3f GB", $3/1024/1024)}')"
echo "RAM_FREE = $(free | awk '/^Mem:/||/^Память:/ {printf("%.3f GB", $4/1024/1024)}')"
echo "SPACE_ROOT = $(df / | awk 'NR==2 {printf("%.3f MB", $2/1024)}')"
echo "SPACE_ROOT_USED = $(df / | awk 'NR==2 {printf("%.3f MB", $3/1024)}')"
echo "SPACE_ROOT_FREE = $(df / | awk 'NR==2 {printf("%.3f MB", $4/1024)}')"

#df -m --output=used /