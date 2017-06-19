#!/bin/sh

set -e

if [ $1 ]; then
	SecretId=$1
fi

if [ $2 ]; then
	SecretKey=$2
fi

if [ $3 ]; then
	Domain=$3
fi

if [ -z "$SecretId" -o -z "$SecretKey" -o -z "$Domain" ]; then
	echo "参数缺失"
	exit 1
fi

if [ $4 ]; then
	SubDomain=$4
fi

if [ -z "$SubDomain" ]; then
	SubDomain="@"
fi

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
	local message="GETcns.api.qcloud.com/v2/index.php?$1"
	local sig=$(echo -n "$message" | openssl dgst -sha256 -hmac "$SecretKey" -binary | openssl base64)
	echo $(urlencode $sig)
}

sendRequest() {
	local nonce=$RANDOM
	local timestamp=$(date '+%s')
	local query="Action=$1&Nonce=$nonce&Region=sh&SecretId=$SecretId&SignatureMethod=HmacSHA256&Timestamp=$timestamp&$2"
	local sig=$(getSignature $query)
	local result=$(wget -qO- --no-check-certificate "https://cns.api.qcloud.com/v2/index.php?$query&Signature=$sig")
	echo $result
}

getRecordId() {
	echo "获取 $SubDomain.$Domain 的 IP..." >&2
	local result=$(sendRequest "RecordList" "domain=$Domain&recordType=A&subDomain=$SubDomain")
	local code=$(echo $result | jq -r '.code')
	
	if [ "$code" = "0" ]; then
		local ip=$(echo $result | jq -r '.data.records[0].value')

		if [ "$ip" = "$NewIP" ]; then
			echo "IP 无变化, 退出脚本..." >&2
			exit 1
		fi

		local recordId=$(echo $result | jq -r '.data.records[0].id')
		echo $recordId
	else
		local error=$(echo $result | jq -r '.message')
		echo "$error" >&2
		exit 1
	fi
}

# $1 = record ID, $2 = new IP
updateRecord() {
	local result=$(sendRequest "RecordModify" "domain=$Domain&recordId=$1&recordLine=默认&recordType=A&subDomain=$SubDomain&value=$2")
	local code=$(echo $result | jq -r '.code')
	
	if [ "$code" = "0" ]; then
		local recordId=$(echo $result | jq -r '.data.record.id')
		echo $RecordId
	else
		local error=$(echo $result | jq -r '.message')
		echo "$error" >&2
		exit 1
	fi
}

# $1 = new IP
addRecord() {
	local result=$(sendRequest "RecordCreate" "domain=$Domain&recordLine=默认&recordType=A&subDomain=$SubDomain&value=$1")
	local code=$(echo $result | jq -r '.code')

	if [ "$code" = "0" ]; then
		local recordId=$(echo $result | jq -r '.data.record.id')
		echo $recordId
	else
		local error=$(echo $result | jq -r '.message')
		echo "$error" >&2
		exit 1
	fi
}

# Get new IP address
echo "获取当前IP..."
NewIP=$(wget -qO- --no-check-certificate http://members.3322.org/dyndns/getip)
echo "当前 IP 为 $NewIP."

# Get record ID of sub domain
RecordId=$(getRecordId)

if [ "$RecordId" = "null" ]; then
	echo "域名记录不存在, 添加 $SubDomain.$Domain 至 $NewIP..."
	RecordId=$(addRecord $NewIP)
else
	echo "域名记录已存在, 更新 $SubDomain.$Domain 至 $NewIP..."
	RecordId=$(updateRecord $RecordId $NewIP)
fi
	
if [ "$RecordId" = "null" ]; then
	echo "更新失败."
else
	echo "$SubDomain.$Domain 已指向 $NewIP."
fi
