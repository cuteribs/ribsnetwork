#!/bin/sh

set -e

HOST="cn.bing.com"
WIDTH=1920
HEIGHT=1080
PATH="./"

if [ $1 ]; then
	WIDTH=$1
fi

if [ $2 ]; then
	HEIGHT=$2
fi

if [ $3 ]; then
	PATH=$3
fi

URL="https://$HOST/HPImageArchive.aspx?format=js&n=1&uhd=1&uhdwidth=$WIDTH&uhdheight=$HEIGHT"

RESULT=$(wget -qO- --no-check-certificate --content-on-error "$URL")


getRecordId() {
	echo "获取 $SubDomain.$Domain 的 IP..." >&2
	local queryString="AccessKeyId=$ApiId&Action=DescribeSubDomainRecords&Format=JSON&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&SubDomain=$SubDomain.$Domain&Timestamp=$Timestamp&Type=A&Version=2015-01-09"
	local result=$(sendRequest "$queryString")
	local code=$(echo $result | sed 's/.*,"Code":"\([A-z]*\)",.*/\1/')
	local recordId=$(echo $result | sed 's/.*,"RecordId":"\([0-9]*\)",.*/\1/')

	if [ "$code" = "$result" ] && [ ! "$recordId" = "$result" ]; then
		local ip=$(echo $result | sed 's/.*,"Value":"\([0-9\.]*\)",.*/\1/')

		if [ "$ip" == "$NewIP" ]; then
			echo "IP 无变化, 退出脚本..." >&2
			echo "quit"
		else
			echo $recordId
		fi
	else
		echo "null"
	fi
}

# $1 = record ID, $2 = new IP
updateRecord() {
	local queryString="AccessKeyId=$ApiId&Action=UpdateDomainRecord&DomainName=$Domain&Format=JSON&RR=$SubDomain&RecordId=$1&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&Timestamp=$Timestamp&Type=A&Value=$2&Version=2015-01-09"
	local result=$(sendRequest $queryString)
	local code=$(echo $result | sed 's/.*,"Code":"\([A-z]*\)",.*/\1/')

	if [ "$code" = "$result" ]; then
		echo "$SubDomain.$Domain 已指向 $NewIP." >&2
	else
		echo "更新失败." >&2
		echo $result >&2
	fi
}

# $1 = new IP
addRecord() {
	local queryString="AccessKeyId=$ApiId&Action=AddDomainRecord&DomainName=$Domain&Format=JSON&RR=$SubDomain&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&Timestamp=$Timestamp&Type=A&Value=$1&Version=2015-01-09"
	local result=$(sendRequest $queryString)
	local code=$(echo $result | sed 's/.*,"Code":"\([A-z]*\)",.*/\1/')

	if [ "$code" = "$result" ]; then
		echo "$SubDomain.$Domain 已指向 $NewIP." >&2
	else
		echo "添加失败." >&2
		echo $result >&2
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