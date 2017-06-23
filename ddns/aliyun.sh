#!/bin/sh

set -e

if [ $1 ]; then
	AccessKeyId=$1
fi

if [ $2 ]; then
	AccessKeySecret=$2
fi

if [ $3 ]; then
	DomainName=$3
fi

if [ -z "$AccessKeyId" -o -z "$AccessKeySecret" -o -z "$DomainName" ]; then
	echo "参数缺失"
	exit 1
fi

if [ $4 ]; then
	SubDomain=$4
fi

if [ -z "$SubDomain" ]; then
	SubDomain="@"
fi

ErrorMessage=""
Nonce=$RANDOM
Timestamp=$(date -u "+%Y-%m-%dT%H%%3A%M%%3A%SZ")	# SB 阿里云, 什么鬼时间格式

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
	local sig=$(echo -n "$message" | openssl dgst -sha1 -hmac "$AccessKeySecret&" -binary | openssl base64)
	echo $(urlencode $sig)
}

sendRequest() {
	local sig=$(getSignature $1)
	local result=$(wget -qO- --no-check-certificate --content-on-error "https://alidns.aliyuncs.com?$1&Signature=$sig")
	echo $result >&2
	echo $result
}

getRecordId() {
	echo "获取 $SubDomain.$DomainName 的 IP..." >&2
	local queryString="AccessKeyId=$AccessKeyId&Action=DescribeSubDomainRecords&Format=JSON&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&SubDomain=$SubDomain.$DomainName&Timestamp=$Timestamp&Type=A&Version=2015-01-09"
	local result=$(sendRequest "$queryString")
	local code=$(echo $result | sed 's/.*,"Code":"\([A-z]*\)",.*/\1/')
	local recordId=$(echo $result | sed 's/.*,"RecordId":"\([0-9]*\)",.*/\1/')

	if [ "$code" = "$result" ] && [ ! "$recordId" = "$result" ]; then
		local ip=$(echo $result | sed 's/.*,"Value":"\([0-9\.]*\)",.*/\1/')

		if [ "$ip" == "$NewIP" ]; then
			echo "IP 无变化, 退出脚本..." >&2
			exit 1
		fi

		echo $recordId
	else
		echo "null"
	fi
}

# $1 = record ID, $2 = new IP
updateRecord() {
	local queryString="AccessKeyId=$AccessKeyId&Action=UpdateDomainRecord&DomainName=$DomainName&Format=JSON&RR=$SubDomain&RecordId=$1&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&Timestamp=$Timestamp&Type=A&Value=$2&Version=2015-01-09"
	local result=$(sendRequest $queryString)
	local code=$(echo $result | sed 's/.*,"Code":"\([A-z]*\)",.*/\1/')

	if [ "$code" = "$result" ]; then
		echo "$SubDomain.$DomainName 已指向 $NewIP." >&2
	else
		echo "更新失败." >&2
		echo $result >&2
		exit 1
	fi
}

# $1 = new IP
addRecord() {
	local queryString="AccessKeyId=$AccessKeyId&Action=AddDomainRecord&DomainName=$DomainName&Format=JSON&RR=$SubDomain&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&Timestamp=$Timestamp&Type=A&Value=$1&Version=2015-01-09"
	local result=$(sendRequest $queryString)
	local code=$(echo $result | sed 's/.*,"Code":"\([A-z]*\)",.*/\1/')

	if [ "$code" = "$result" ]; then
		echo "$SubDomain.$DomainName 已指向 $NewIP." >&2
	else
		echo "添加失败." >&2
		echo $result >&2
		exit 1
	fi
}

# Get new IP address
echo "获取当前 IP..."
NewIP=$(wget -qO- --no-check-certificate "http://members.3322.org/dyndns/getip")
echo "当前 IP 为 $NewIP."

# Get record ID of sub domain
recordId=$(getRecordId)

if [ "$recordId" = "null" ]; then
	echo "域名记录不存在, 添加 $SubDomain.$DomainName 至 $NewIP..."
	recordId=$(addRecord $NewIP)
else
	echo "域名记录已存在, 更新 $SubDomain.$DomainName 至 $NewIP..."
	recordId=$(updateRecord $recordId $NewIP)
fi