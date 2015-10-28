#!/bin/sh

. $(dirname $0)/functions.sh

# add some ip rules to prevent the router from trying to connect to the vpn-server
# via mesh.
for v in $vpnservers; do
	ips="$(resolve $v)"
	for ip in $ips; do
		add_rule $ip
	done
done

logger -s ovpn-up -t openvpn "dev: $dev, ifconfig_remote: $ifconfig_remote"

# iterate over all routes in main table with dev ipredator
# and add a default route via this $dev to table olsr-default

ip route show dev $dev | while read rule; do
	echo $rule
        ip route del $rule
	logger -s ovpn-up -t openvpn "delete route $rule from main table"
        
	echo $rule |grep -q '0.0.0.0' && {
		logger -s ovpn-up -t openvpn "found gateway: $gw"
                gw="`echo $rule | cut -d ' ' -f 3`"
	        ip route add default via $gw dev "$dev" table olsr-default
		logger -s ovpn-up -t openvpn "added default gw $gw for table olsr-default."
        }
        # 0.0.0.0/1 via 46.246.42.1 dev ipredator
        #46.246.42.0/24 dev ipredator  proto kernel  scope link  src 46.246.42.57
        #128.0.0.0/1 via 46.246.42.1 dev ipredator
done

#[ -z "`ip route show table olsr-default |grep "default via $ifconfig_remote dev $dev"`" ] && ip route add default via $ifconfig_remote dev $dev table olsr-default
#[ -z "`ip route show |grep "192.168.202.1 via $ifconfig_remote dev $dev"`" ] && ip route add 192.168.202.1 via $ifconfig_remote dev $dev


