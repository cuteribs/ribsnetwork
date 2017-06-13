#!/bin/sh

if [ -f /tmp/certbot/record_id ]; then
	RecordIds=$(cat /tmp/certbot/record_id)
fi

if [ -n "$RecordIds" ]; then
	Domain=$(echo $CERTBOT_DOMAIN | sed 's/.*\.\([^.]*\..*\)/\1/')
	
	for i in $(cat /tmp/certbot/record_id); do 
		wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&record_id=$i" https://dnsapi.cn/Record.Remove
	done
	
	rm -rf /tmp/certbot/record_id
fi
