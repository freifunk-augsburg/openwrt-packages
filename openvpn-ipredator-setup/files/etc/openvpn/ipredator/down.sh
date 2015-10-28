#!/bin/sh
. $(dirname $0)/functions.sh

# resolve all vpn servers ips
resolved=""
for v in $vpnservers; do
	resolved="$resolved $(resolve $v)"
done


# Remove all ip rules with prio 99999 that are not vpn servers
# Config or DNS might have changed

ip rule show | grep 99999 | while read line; do
	ip="$(echo $line| sed -n 's/99999: from all to \([0-9a-f\.:]*\) unreachable$/\1/p')"
	if [ -n "$ip" ]; then
		echo "$resolved" |grep "$ip" || remove_rule $ip
	fi
done

exit 0
