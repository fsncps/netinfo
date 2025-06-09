#!/bin/bash

export PATH=$PATH:/sbin:/usr/sbin
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

file="$DIR/interface.txt"

wifi_pid=""
speed_pid=""

while true; do
   # Check if any network interface is up
   interfaces=$(ip link show up | awk -F: '$1 ~ /^[0-9]+$/ {print $2}' | tr -d ' ')

   if [[ -z "$interfaces" ]]; then
      echo "interface down" >"$file"

      # Kill wifi.sh and speed.sh if they are running
      if [[ -n "$wifi_pid" ]]; then
         kill "$wifi_pid" 2>/dev/null
         wifi_pid=""
      fi
      if [[ -n "$speed_pid" ]]; then
         kill "$speed_pid" 2>/dev/null
         speed_pid=""
      fi

   else
      eth_ip=""
      wifi_ip=""

      # Check active interfaces and get their IPs
      for iface in $interfaces; do
         ip_addr=$(ip -4 addr show "$iface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

         if [[ "$iface" == "eth0" && -n "$ip_addr" ]]; then
            eth_ip=$ip_addr
         elif [[ "$iface" == "wlan"* || "$iface" == "wifi"* ]] && [[ -n "$ip_addr" ]]; then
            wifi_ip=$ip_addr
         fi
      done

      # Update status
      if [[ -n "$eth_ip" && -z "$wifi_ip" ]]; then
         echo "eth0 up: $eth_ip" >"$file"
      elif [[ -z "$eth_ip" && -n "$wifi_ip" ]]; then
         echo "WiFi up: $wifi_ip" >"$file"
      elif [[ -n "$eth_ip" && -n "$wifi_ip" ]]; then
         echo "WiFi up: $wifi_ip / eth0 up: $eth_ip" >"$file"
      else
         echo "Offline" >"$file"
      fi

      # Start wifi.sh and speed.sh if not running
      if [[ -z "$wifi_pid" ]]; then
         $DIR/wifi.sh &
         wifi_pid=$!
      fi
      if [[ -z "$speed_pid" ]]; then
         $DIR/speed.sh &
         speed_pid=$!
      fi
   fi

   sleep 60
done
