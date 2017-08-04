#!/bin/sh

PRIVOXY_CONF="/app/privoxy.conf"

if [ ! -f "$PRIVOXY_CONF" ]; then
	touch PRIVOXY_CONF
	echo listen-address 0.0.0.0:$HTTP > $PRIVOXY_CONF
	echo forward-socks5 / forward-server:$SOCKS5 . >> $PRIVOXY_CONF
fi

privoxy --no-daemon $PRIVOXY_CONF