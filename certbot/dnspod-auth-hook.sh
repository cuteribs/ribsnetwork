#!/bin/sh

# Get your API Token from https://www.dnspod.cn/console/user/security
# LoginToken="$API_ID,API_Token"		# "13490,6b5976c68aba5b14a0558b77c17c3932"

Domain=$(echo $CERTBOT_DOMAIN | sed 's/.*\.\([^.]*\..*\)/\1/')
SubDomain=$(echo "_acme-challenge.$CERTBOT_DOMAIN" | sed 's/\(.*\)\..*\..*/\1/')

# Remove the DNS record if it already exists
Response=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain" https://dnsapi.cn/Record.List)
Code=$(echo $Response | sed 's/.*{"code":"\([0-9]*\)".*/\1/')

if [ "$Code" -eq "1" ]; then
	echo -e "$SubDomain.$Domain is found and being deleted.\n"
	RecordId=$(echo $Response | sed 's/.*"records":\[{"id":"\([0-9]*\)".*/\1/')
	Response=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&record_id=$RecordId" https://dnsapi.cn/Record.Remove)
fi

# Create TXT record
Response=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain&record_type=TXT&record_line_id=0&value=$CERTBOT_VALIDATION" https://dnsapi.cn/Record.Create)
Code=$(echo $Response | sed 's/.*{"code":"\([0-9]*\)".*/\1/')

if [ "$Code" -eq "1" ]; then
	echo -e "TXT record is created as $SubDomain.$Domain = $CERTBOT_VALIDATION\n"
	echo -e "Waiting for 15 seconds"
	sleep 10
fi

