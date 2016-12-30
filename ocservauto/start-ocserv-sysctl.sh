#!/bin/bash

#vars
OCSERV_CONFIG="/etc/ocserv/ocserv.conf"

# turn on IP forwarding
#sysctl -w net.ipv6.conf.all.forwarding=1 > /dev/null 2>&1
sysctl -w net.ipv4.ip_forward=1 > /dev/null 2>&1

#get gateway and profiles
gw_intf_oc=`ip route show|sed -n 's/^default.* dev \([^ ]*\).*/\1/p'`
ocserv_tcpport=`sed -n 's/^tcp-.*=[ \t]*//p' $OCSERV_CONFIG`
ocserv_udpport=`sed -n 's/^udp-.*=[ \t]*//p' $OCSERV_CONFIG`
ocserv_ip4_work_mask=`sed -n 's/^ipv4-.*=[ \t]*//p' $OCSERV_CONFIG|sed 'N;s|\n|/|g'`


# turn on NAT over default gateway and VPN
if !(iptables-save -t nat | grep -q "$gw_intf_oc (ocserv)"); then
iptables -t nat -A POSTROUTING -s $ocserv_ip4_work_mask -o $gw_intf_oc -m comment --comment "$gw_intf_oc (ocserv)" -j MASQUERADE
fi

if !(iptables-save -t filter | grep -q "$gw_intf_oc (ocserv2)"); then
iptables -A FORWARD -s $ocserv_ip4_work_mask -m comment --comment "$gw_intf_oc (ocserv2)" -j ACCEPT
fi

if !(iptables-save -t filter | grep -q "$gw_intf_oc (ocserv3)"); then
iptables -A INPUT -p tcp --dport $ocserv_tcpport -m comment --comment "$gw_intf_oc (ocserv3)" -j ACCEPT
fi

if [ "$ocserv_udpport" != "" ]; then
    if !(iptables-save -t filter | grep -q "$gw_intf_oc (ocserv4)"); then
        iptables -A INPUT -p udp --dport $ocserv_udpport -m comment --comment "$gw_intf_oc (ocserv4)" -j ACCEPT
    fi
fi

if !(iptables-save -t filter | grep -q "$gw_intf_oc (ocserv5)"); then
iptables -A FORWARD  -m state --state RELATED,ESTABLISHED -m comment --comment "$gw_intf_oc (ocserv5)" -j ACCEPT
fi

# turn on MSS fix
# MSS = MTU - TCP header - IP header
if !(iptables-save -t mangle | grep -q "$gw_intf_oc (ocserv6)"); then
iptables -t mangle -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -m comment --comment "$gw_intf_oc (ocserv6)" -j TCPMSS --clamp-mss-to-pmtu
fi
