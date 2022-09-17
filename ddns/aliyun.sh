#!/bin/sh

set -e

if [ $1 ]; then
	ApiId=$1
fi

if [ $2 ]; then
	ApiKey=$2
fi

if [ $3 ]; then
	Domain=$3
fi

if [ -z "$ApiId" -o -z "$ApiKey" -o -z "$Domain" ]; then
	echo "参数缺失"
	exit 1
fi

if [ $4 ]; then
	SubDomain=$4
fi

if [ -z "$SubDomain" ]; then
	SubDomain="%40"
fi

Nonce=$(date -u "+%N")	# 有bug?
Timestamp=$(date -u "+%Y-%m-%dT%H%%3A%M%%3A%SZ")	# SB 阿里云, 什么鬼时间格式
Nonce=$Timestamp

urlencode() {
	local raw="$1";
	local len="${#raw}"
	local encoded=""

	for i in `seq 1 $len`; do
		local j=$((i+1))
		local c=$(echo $raw | cut -c$i-$i)

		case $c in [a-zA-Z0-9.~_-]) ;;
			*)
			c=$(printf '%%%02X' "'$c") ;;
		esac

		encoded="$encoded$c"
	done

	echo $encoded
}

# $1 = query string
getSignature() {
	local encodedQuery=$(urlencode $1)
	local message="GET&%2F&$encodedQuery"
	local sig=$(echo -n "$message" | openssl dgst -sha1 -hmac "$ApiKey&" -binary | openssl base64)
	echo $(urlencode $sig)
}

sendRequest() {
	local sig=$(getSignature $1)
	local result=$(wget -qO- --no-check-certificate --content-on-error "https://alidns.aliyuncs.com?$1&Signature=$sig")
	echo $result
}

getRecordId() {
	local domain="$Domain"
	
	if [ ! "$SubDomain" = "%40" ]; then
		domain="$SubDomain.$Domain"
	fi
	
	echo "获取 $domain 的 IP..." >&2
	local queryString="AccessKeyId=$ApiId&Action=DescribeSubDomainRecords&Format=JSON&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&SubDomain=$domain&Timestamp=$Timestamp&Type=A&Version=2015-01-09"
	local result=$(sendRequest "$queryString")
	local recordId=$(echo $result | jq -r '.DomainRecords[] | .[0].RecordId')

	if [ "$recordId" = "null" ]; then
		echo "null"
	else
		local ip=$(echo $result | jq -r '.DomainRecords[] | .[0].Value')

		if [ "$ip" == "$NewIP" ]; then
			echo "IP 无变化, 退出脚本..." >&2
			echo "quit"
		else
			echo $recordId
		fi
	fi
}

# $1 = record ID, $2 = new IP
updateRecord() {
	local queryString="AccessKeyId=$ApiId&Action=UpdateDomainRecord&DomainName=$Domain&Format=JSON&RR=$SubDomain&RecordId=$1&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&Timestamp=$Timestamp&Type=A&Value=$2&Version=2015-01-09"
	local result=$(sendRequest $queryString)
	local recordId=$(echo $result | jq -r '.RecordId')
	
	if [ "$recordId" = "null" ]; then
		local code=$(echo $result | jq -r '.Code')
		local message=$(echo $result | jq -r '.Message')
		echo "更新失败: $code, $message" >&2
	else
		echo "$SubDomain.$Domain 已指向 $NewIP." >&2
	fi
}

# $1 = new IP
addRecord() {
	local queryString="AccessKeyId=$ApiId&Action=AddDomainRecord&DomainName=$Domain&Format=JSON&RR=$SubDomain&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&Timestamp=$Timestamp&Type=A&Value=$1&Version=2015-01-09"
	local result=$(sendRequest $queryString)
	local recordId=$(echo $result | jq -r '.RecordId')
	
	if [ "$recordId" = "null" ]; then
		local code=$(echo $result | jq -r '.Code')
		local message=$(echo $result | jq -r '.Message')
		echo "添加失败: $code, $message" >&2
	else
		echo "$SubDomain.$Domain 已指向 $NewIP." >&2
	fi
}

# Get new IP address
echo "获取当前 IP..."
NewIP=$(wget -qO- --no-check-certificate "http://members.3322.org/dyndns/getip")
echo "当前 IP 为 $NewIP."

# Get record ID of sub domain
recordId=$(getRecordId)

if [ ! "$recordId" = "quit" ]; then
	if [ "$recordId" = "null" ]; then
		echo "域名记录不存在, 添加 $SubDomain.$Domain 至 $NewIP..."
		addRecord $NewIP
	else
		echo "域名记录已存在, 更新 $SubDomain.$Domain 至 $NewIP..."
		updateRecord $recordId $NewIP
	fi
fi