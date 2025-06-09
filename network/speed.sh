#!/bin/bash
#
#
export PATH=$PATH:/sbin:/usr/sbin
tmpfile="/home/fsncps/.scripts/infoscreen/network/tmpspeed"
file="/home/fsncps/.scripts/infoscreen/network/speed.txt"

while true; do
   speedtest >"$tmpfile"
   cat "$tmpfile"
   grep -e Hosted -e Download -e Upload "$tmpfile" >"$file"
   sed -i 's/Hosted by .* (\([^)]*\))/[\1]/' "$file"
   cat "$file"
   sleep 30
done
