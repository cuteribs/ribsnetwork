#!/bin/bash

if [ $1 ]; then
	LoginToken=$1
fi

if [ $2 ]; then
	Domain=$2
fi

if [ $3 ]; then
	SubDomain=$3
fi

if [ -z "$SubDomain" ]; then
	SubDomain="@"
fi

Result=""
Code=""
Message=""
LastIP=""
LastIPFile="/tmp/last_ip"

if [ -f "$LastIPFile" ]; then
	LastIP=$(cat "$LastIPFile")
fi

# Get new IP address
NewIP=$(wget -qO- http://members.3322.org/dyndns/getip)

# Quit the script if no IP change
if [ "$NewIP" == "$LastIP" ]; then
	echo "$SubDomain.$Domain == $NewIP, no change made!"
	exit 0
fi

# Get record ID of sub domain
Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain" https://dnsapi.cn/Record.List)
Code=$(echo $Result | jq -r '.status.code')
	
if [ "$Code" == "1" ]; then
	RecordId=$(echo $Result | jq -r '.records[0].id')
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&record_id=$RecordId&record_type=A&record_line_id=0&sub_domain=$SubDomain&value=$NewIP" https://dnsapi.cn/Record.Modify)
	Code=$(echo $Result | jq -r '.status.code')

	if [ "$Code" == "1" ]; then
		echo "$SubDomain.$Domain => $NewIP, IP updated."
	else
		echo $Result | jq -r '.status.message'
		exit -1
	fi	
else
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain&record_type=A&record_line_id=0&value=$NewIP" https://dnsapi.cn/Record.Create)
	Code=$(echo $Result | jq -r '.status.code')

	if [ "$Code" == "1" ]; then
		echo "$SubDomain.$Domain => $NewIP, IP updated."
	else
		echo $Result | jq -r '.status.message'
		exit -1
	fi	
fi