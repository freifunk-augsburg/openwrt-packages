#!/bin/sh

vpnservers="$(/bin/grep remote /etc/openvpn/ipredator/openvpn-ipredator.conf  | awk '{ print $2 }')"

resolve() {
	echo "$(nslookup $1 2>/dev/null |grep 'Address' |grep -v '127.0.0.1' |awk '{ print $3 }')"
}

add_rule() {
	ip=$1
	case $ip in
		*:*) cmd="/usr/sbin/ip -6";;
		*) cmd="/usr/sbin/ip"
	esac
	$cmd rule show | grep -q "to $ip unreachable" || {
		$cmd rule add to $ip prio 99999 unreachable && {
			logger -t openvpn "Added rule: $cmd rule add to $ip prio 99999 unreachable"
		} || logger -t openvpn "Error adding rule: $cmd rule add to $ip prio 99999 unreachable"
	}
}

remove_rule() {
	ip=$1
	case $ip in
		*:*) cmd="/usr/sbin/ip -6";;
		*) cmd="/usr/sbin/ip"
	esac
	$cmd rule del to $ip prio 99999 unreachable && {
		logger -s openvpn "Removed rule: $cmd rule del to $ip prio 99999 unreachable"
	} || logger -s openvpn "Error removing rule: $cmd rule del to $ip prio 99999 unreachable"
}
