#!/bin/bash
#
#
export PATH=$PATH:/sbin:/usr/sbin
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while true; do
   echo "$(curl -s ifcfg.me) through $(iwgetid -r) @ $(nslookup $(ip route | grep default | awk '{print $3}') | grep 'name = ' | awk -F' = ' '{print $2}' | sed 's/\.$//' | head -n 1) ($(iwconfig wlan0 | grep -oP '(?<=Signal level=)-?\d+ dBm'))" >$DIR/wifi.txt
   sleep 2
done
# echo "$(curl -s ifcfg.me) / $(ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}') on $(iwgetid -r): $(nslookup $(ip route | grep default | awk '{print $3}') | grep 'name = ' | awk -F' = ' '{print $2}' | sed 's/\.$//' | head -n 1) ($(iwconfig wlan0 | grep -oP '(?<=Signal level=)-?\d+ dBm'))" >/opt/scripts/infoscreen/network/wifi.txt
# sleep 2
