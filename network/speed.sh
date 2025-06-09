#!/bin/bash
#
#
export PATH=$PATH:/sbin:/usr/sbin
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmpfile="$DIR/tmpspeed"
file="$DIR/speed.txt"

while true; do
   speedtest >"$tmpfile"
   cat "$tmpfile"
   grep -e Hosted -e Download -e Upload "$tmpfile" >"$file"
   sed -i 's/Hosted by .* (\([^)]*\))/[\1]/' "$file"
   cat "$file"
   sleep 30
done
