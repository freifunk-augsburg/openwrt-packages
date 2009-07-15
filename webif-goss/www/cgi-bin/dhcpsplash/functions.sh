## vars
SADR=$(uci get network.ath0.ipaddr)

# soma
#if [ -z "$SADR" ]; then
#	SADR=$(nvram get lan_ipaddr)
#fi

splash_running() {
	iptables -n -t nat -L PREROUTING | grep -q "^dhcpsplash "
}

splash_getmac() {
	grep -is "$1" /proc/net/arp |
	if read ip type flags mac mask iface; then echo "$mac"
	else grep -is "$1" /var/run/dhcp.leases | cut -d " " -f2; fi
}

splash_insertmac() {
	iptables -t nat -I auth_users -m mac --mac-source "$1" -j ACCEPT >/dev/null 2>&1
	logger -t dhcpsplash "Inserting Client $1"
}

splash_removemac() {
	iptables -t nat -D auth_users -m mac --mac-source "$1" -j ACCEPT >/dev/null 2>&1
	logger -t dhcpsplash "removing client $1"
}

splash_isblockedmac() {
	grep -iqs "$1" /etc/dhcpsplash/blocked
}

splash_ispreauthmac() {
	grep -iqs "$1" /etc/dhcpsplash/preauth
}

splash_isknownmac() {
	iptables -n -t nat -L auth_users 2>/dev/null | grep -iqs "ACCEPT.*$1"
}

# options and settings
splash_gettext() {
	cat "/etc/dhcpsplash/$1" 2>/dev/null && return
	cat "/www/cgi-bin/dhcpsplash/$1" 2>/dev/null
}

splash_forcedvar() {
	grep -q "^$1=" /www/cgi-bin/dhcpsplash/forced
}

splash_setvar() {
#soma
	splash_forcedvar "$1" || nvram unset $1
}

splash_getvar() {
	val=$(sed -n "s/^$1=//p" /www/cgi-bin/dhcpsplash/forced)
	test -n "$val" && echo "$val" && return
#soma
#	val=$(nvram get $1)
	test -n "$val" && echo "$val" && return
	sed -n "s/^$1=//p" /www/cgi-bin/dhcpsplash/defaults
}

# parse public services file
splash_public_service() {
	PROTO="${1%% *}"
	DEST="${1#* }"
	PORTS="${DEST#*:}"
	ACTION="-A"
	test "$2" = "delete" && ACTION="-D"
	test "$PROTO" = "icmp" -o "$PROTO" = "udp" -o "$PROTO" = "tcp" || unset PROTO
	test "$PROTO" = "$DEST" && unset DEST
	test "$PORTS" = "$DEST" -o "$PROTO" = "$PORTS" && unset PORTS || DEST=${DEST%%:*}
	test -n "$PROTO" && PROTO="-p $PROTO"
	test -n "$DEST" && DEST="-d $DEST"
	echo "public_services: PROTO=$PROTO, DEST=$DEST, PORTS=$PORTS, ACTION=$ACTION" >&2
	if [ -n "$PORTS" ]; then
		(IFS=",";for PR in $PORTS;do
			P1=${PR%-*}
			P2=${PR#*-}
			(IFS=" ";iptables -t nat $ACTION public_services $PROTO $DEST --dport $P1:$P2 -j ACCEPT)
		done)
	else
		iptables -t nat $ACTION public_services $PROTO $DEST -j ACCEPT
	fi
}

splash_update_public_services() {
	iptables -t nat -F public_services
	psfile="/etc/dhcpsplash/public_services"
	test -f "$psfile" || psfile="/www/cgi-bin/dhcpsplash/public_services"
	while read line ; do
		test -z "$line" && continue
		splash_public_service "$line"
	done < "$psfile"
}

# preauth and blocked
splash_update_preauth() {
	## read preauthenticated macs from file
	if [ -f /etc/dhcpsplash/preauth ] ; then 
  	while read mac hostname ; do
			test -z "$mac" && continue
			splash_isknownmac "$mac" && continue
			splash_insertmac "$mac"
  	done < /etc/dhcpsplash/preauth
	fi
}

splash_update_ipranges() {
	## flush dhcpsplash chain
	iptables -t nat -F dhcpsplash
#soma	
#	LANRANGE=$(splash_lanrange)
#	LANDEV=$(uci get network.ath0.ipaddr)
#	if [ -n "$LANRANGE" ]; then
#		iptables -t nat -A dhcpsplash -i $LANDEV -s $LANRANGE -j dhcpsplash_filter
#	fi
	WIFIDEV="ath0"
	WIFIRANGE=$(uci get network.ath0.dhcp)
	if [ -n "$WIFIRANGE" ]; then
		iptables -t nat -A dhcpsplash -i $WIFIDEV -s $WIFIRANGE -j dhcpsplash_filter
	fi
}

splash_update_blocked() {
	## remove blocked mac adresses from auth_users
	if [ -f /etc/dhcpsplash/blocked ] ; then 
  	while read mac hostname ; do
			test -z "$mac" && continue
			splash_isknownmac "$mac" && splash_removemac "$mac"
  	done < /etc/dhcpsplash/blocked
	fi
}

splash_update_iptables() {
	splash_update_ipranges 2>/dev/null
	splash_update_public_services 2>/dev/null
	splash_update_preauth 2>/dev/null
	splash_update_blocked 2>/dev/null
}

## ip ranges
splash_ifrange() {
ifname=$(uci show network.ath0.ipaddr)
test -z "$ifname" && return
ip addr | sed -n "s/^ *inet \([0-9\.\/]*\) .*$ifname$/\1/p"
}

splash_ifmac() {
ifname=$(uci show network.ath0.ipaddr)
test -z "$ifname" && return
ip addr | sed -n "/^[0-9: ]*$ifname/,/^[0-9]/s/ *link\/ether \([0-9a-f\:\.\/]*\) .*$/\1/p" 
}

# lookup ip (pramter) in wifi and wan iprange and return ip of interface if found
splash_ifipforip() {
	for iprange in $(splash_ifrange wifi) $(splash_ifrange lan); do
		mask=$(echo $iprange | cut -d'/' -f2)
		test "$(ipcalc -ns $iprange)" != "$(ipcalc -ns $1/$mask)" && continue
		echo $iprange | cut -d'/' -f1
		return
	done
}

splash_insplashrange() {
#soma
	for iprange in $(splash_wifirange) $(splash_lanrange); do
#logger -t dhcpsplash "Iprange: $iprange"

mask=$(echo $iprange | cut -d'/' -f2)

#logger -t dhcpsplash "Mask: $mask"
###
### !!!!!!!!!! ########
###
### The bug is here: ipcalc is only a awk script on kamikaze
###

#		test "$(ipcalc -ns $iprange)" != "$(ipcalc -ns $1/$mask)" && continue


test "$(ipcalc $iprange |grep NETWORK)" != "$(ipcalc $1/$mask |grep NETWORK)" && continue

#logger -t dhcpsplash "var1: $1"
		return 0
	done
	return 1
logger -t dhcpsplash "function returned 1"
}

splash_wifirange() {
	opt=$(splash_getvar ff_dhcpsplash_wifi)
	test -n "$opt" || return
	case $opt in
	off)
		return
		;;
	dhcp)
		uci get network.ath0.dhcp | cut -d , -f1
		return
		;;
	net)
		splash_ifrange wifi
		return
		;;
	esac
	echo "$opt"
}

splash_lanrange() {
	opt=$(splash_getvar ff_dhcpsplash_lan)
	test -n "$opt" || return
	case $opt in
	off)
		return
		;;
	net)
		splash_ifrange lan
		return
		;;
	esac
	echo "$opt"
}

# bugfix
unescape()
{
(echo -n ${1%%%*}
if [ -n "$1" ] && [ "$1" != "${1#*%}" ];then
IFS=\%
set ${1#*%}
unset IFS
for i in "$@";do
echo -n -e "\\x$(echo $i|dd bs=1 count=2 2>&-)"
echo -n ${i#??}
done
fi)|sed -e "s/+/ /g"
}
