#!/bin/bash

if [ $1 ]; then
	SecretId=$1		# AKIDHPK4asplMiqjNmhta2GEwNYUAZibpNuB
fi

if [ $2 ]; then
	SecretKey=$2	# A4i6E6i4A0ZsugCRQ9coMgmdFclfNq55
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

getNounce() {
	echo $RANDOM
}

getTimestamp() {
	echo date '+%s'
}

LastIP=""
LastIPFile="/tmp/last_ip"

if [ -f "$LastIPFile" ]; then
	LastIP=$(cat "$LastIPFile")
	echo "Last IP $LastIP is found."
fi

# Get new IP address
echo "Retreiving current IP..."
NewIP=$(wget -qO- http://members.3322.org/dyndns/getip)
echo "Current IP $NewIP is retrieved."

# Quit the script if no IP change
if [ "$NewIP" = "$LastIP" ]; then
	echo "No IP change, quiting the script..."
	exit 0
fi

# Get record ID of sub domain
echo "Retreiving the record ID of $SubDomain.$Domain..."
Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain" https://dnsapi.cn/Record.List)
Code=$(echo $Result | jq -r '.status.code')

if [ "$Code" = "1" ]; then
	RecordId=$(echo $Result | jq -r '.records[0].id')
	echo "Record ID $RecordId exists."
	echo "Pointing $SubDomain.$Domain to $NewIP..."
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&record_id=$RecordId&record_type=A&record_line_id=0&sub_domain=$SubDomain&value=$NewIP" https://dnsapi.cn/Record.Modify)
	Code=$(echo $Result | jq -r '.status.code')

	if [ "$Code" = "1" ]; then
		echo "$SubDomain.$Domain is now pointed to $NewIP."
	else
		echo "Failed to update IP of $SubDomain.$Domain."
		echo $Result | jq -r '.status.message'
		exit -1
	fi	
else
	echo "Record ID does not exist."
	echo "Pointing $SubDomain.$Domain to $NewIP..."
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain&record_type=A&record_line_id=0&value=$NewIP" https://dnsapi.cn/Record.Create)
	Code=$(echo $Result | jq -r '.status.code')

	if [ "$Code" = "1" ]; then
		echo "$SubDomain.$Domain => $NewIP, IP updated."
	else
		echo "Failed to update IP of $SubDomain.$Domain."
		echo $Result | jq -r '.status.message'
		exit -1
	fi	
fi

echo "$NewIP" > $LastIPFile

getSignature() {
	echo -n "$1" | openssl dgst -sha256 -hmac "$2" -binary | openssl base64
}


getRecordId() {
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain" https://dnsapi.cn/Record.List)
	
Code=Code=$(echo $Result | jq -r '.status.code')
}

#--------------------------------








#!/bin/sh

if [ -f saved_ip ]
then . saved_ip
else saved_ip=""; record_id=""
fi

ip=`curl http://whatismyip.akamai.com/ 2>/dev/null`
if [ "$ip" = "$saved_ip" ]
then
    echo "skipping"
    exit 0
fi

name=home
domain=kyrios.pub
timestamp=`date -u "+%Y-%m-%dT%H%%3A%M%%3A%SZ"`
ak=你的阿里云app key
sk="你的阿里云app secret&"

urlencode() {
    # urlencode <string>

    local length="${#1}"
    i=0
    out=""
    for i in $(awk "BEGIN { for ( i=0; i<$length; i++ ) { print i; } }")
    do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9._-]) out="$out$c" ;;
            *) out="$out`printf '%%%02X' "'$c"`" ;;
        esac
        i=$(($i + 1))
    done
    echo -n $out
}

send_request() {
    args="AccessKeyId=$ak&Action=$1&Format=json&$2&Version=2015-01-09"
    hash=$(urlencode $(echo -n "GET&%2F&$(urlencode $args)" | openssl dgst -sha1 -hmac $sk -binary | openssl base64))
    curl "http://alidns.aliyuncs.com/?$args&Signature=$hash" 2> /dev/null
}

get_recordid() {
    grep -Eo '"RecordId":"[0-9]+"' | cut -d':' -f2 | tr -d '"'
}

query_recordid() {
    send_request "DescribeSubDomainRecords" "SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&SubDomain=$name.$domain&Timestamp=$timestamp"
}

update_record() {
    send_request "UpdateDomainRecord" "RR=$name&RecordId=$1&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&Timestamp=$timestamp&Type=A&Value=$ip"
}

add_record() {
    send_request "AddDomainRecord&DomainName=$domain" "RR=$name&SignatureMethod=HMAC-SHA1&SignatureNonce=$timestamp&SignatureVersion=1.0&Timestamp=$timestamp&Type=A&Value=$ip"
}

if [[ "$record_id" = "" ]]
then
    record_id=`query_recordid | get_recordid`
    if [[ "$record_id" = "" ]]
    then
        record_id=`add_record | get_recordid`
    else
        update_record $record_id
    fi
fi
# save to file
echo "record_id=$record_id; saved_ip=$ip" > saved_ip