#!/bin/bash
#
#
export PATH=$PATH:/sbin:/usr/sbin
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while true; do
   if iwgetid -r >/dev/null 2>&1; then
      SSID=$(iwgetid -r)
      SIGNAL=$(iwconfig wlan0 | grep -oP '(?<=Signal level=)-?\d+ dBm')
      GW_HOST=$(nslookup "$(ip route | awk '/default/ {print $3}')" | awk -F' = ' '/name =/ {gsub(/\.$/, "", $2); print $2; exit}')
      echo "$(curl -s ifcfg.me) through $SSID @ $GW_HOST ($SIGNAL)" >"$DIR/wifi.txt"
   else
      GW=$(ip route | awk '/default/ {print $3}')
      echo "$(curl -s ifcfg.me) through ethernet ($GW)" >"$DIR/wifi.txt"
   fi
   sleep 2
done
