#!/bin/bash

if [ $1 ]; then
	Token=$1
fi

if [ $2 ]; then
	Domain=$2
fi

if [ $3 ]; then
	SubDomain=$3
fi

NewIP=$(curl http://members.3322.org/dyndns/getip 2>/dev/null)
RecordId=$(curl -X POST https://dnsapi.cn/Record.List -d "login_token=$Token&format=json&domain=$Domain&sub_domain=$SubDomain" 2>/dev/null)
RecordId=$(echo $RecordId | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
Result=$(curl -X POST https://dnsapi.cn/Record.Ddns -d "login_token=$Token&format=json&domain=$Domain&record_id=$RecordId&record_line_id=0&sub_domain=$SubDomain&value=$NewIP" 2>/dev/null)
Result=$(echo $Result | sed 's/.*,"message":"\([^"]*\)".*/\1/')
echo "$Result"
echo "$SubDomain.$Domain => $NewIP"
