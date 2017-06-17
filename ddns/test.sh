#!/bin/sh

urlencode() 
{
	local string="$1"
	local strlen=${#string}
	local encoded=""
	local pos c o
	
	for (( pos=0 ; pos<strlen ; pos++ )); do
		c=${string:$pos:1}
		case "$c" in [-_.~a-zA-Z0-9] ) 
			o="$c" ;; * )
			printf -v o '%%%02X' "'$c"
		esac
		encoded+="${o}"
	done
	
	echo ${encoded}
}

urlencode 'AccessKeyId=testid&Action=DescribeDomainRecords&DomainName=example.com&SignatureMethod=HMAC-SHA1&SignatureNonce=f59ed6a9-83fc-473b-9cc6-99c95df3856e&SignatureVersion=1.0&Version=2015-01-09&Timestamp=2016-03-24T16:41:54Z'