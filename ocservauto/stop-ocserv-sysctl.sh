#! /bin/bash


# uncomment if you want to turn off IP forwarding
# sysctl -w net.ipv4.ip_forward=0

#del iptables

iptables-save | grep 'ocserv' | sed 's/^-A P/iptables -t nat -D P/' | sed 's/^-A FORWARD -p/iptables -t mangle -D FORWARD -p/' | sed 's/^-A/iptables -D/' | bash

