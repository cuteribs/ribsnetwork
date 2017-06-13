#!/bin/bash

if [ $1 ]; then
	SecretId=$1
fi

if [ $2 ]; then
	SecretKey=$2
fi

if [ $3 ]; then
	Domain=$3
fi

getSignature() {
	return $(echo -n "$1" | openssl dgst -sha256 -hmac "$2" -binary | openssl base64)
}


NewIP=$(curl http://members.3322.org/dyndns/getip 2>/dev/null)
RecordId=$(curl -X POST https://dnsapi.cn/Record.List -d "login_token=$Token&format=json&domain=$Domain&sub_domain=$SubDomain" 2>/dev/null)
RecordId=$(echo $RecordId | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')
Result=$(curl -X POST https://dnsapi.cn/Record.Ddns -d "login_token=$Token&format=json&domain=$Domain&record_id=$RecordId&record_line_id=0&sub_domain=$SubDomain&value=$NewIP" 2>/dev/null)
Result=$(echo $Result | sed 's/.*,"message":"\([^"]*\)".*/\1/')
echo "$Result"
echo "$SubDomain.$Domain => $NewIP"






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