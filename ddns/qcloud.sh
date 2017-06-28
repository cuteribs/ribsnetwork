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
	SubDomain="@"
fi

Nonce=$(date +%N)
Timestamp=$(date '+%s')

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
	local sig=$(echo -n "$message" | openssl dgst -sha256 -hmac "$ApiKey" -binary | openssl base64)
	echo $(urlencode $sig)
}

sendRequest() {
	local query="Action=$1&Nonce=$Nonce&Region=sh&SecretId=$ApiId&SignatureMethod=HmacSHA256&Timestamp=$Timestamp&$2"
	local sig=$(getSignature $query)
	local result=$(wget -qO- --no-check-certificate --content-on-error "https://cns.api.qcloud.com/v2/index.php?$query&Signature=$sig")
	echo $result
}

getRecordId() {
	echo "获取 $SubDomain.$Domain 的 IP..." >&2
	local result=$(sendRequest "RecordList" "domain=$Domain&recordType=A&subDomain=$SubDomain")
	local code=$(echo $result | sed 's/.*{"code":\([0-9]*\),.*/\1/')
	local recordId=$(echo $result | sed 's/.*\[{"id":\([0-9]*\).*/\1/')
	
	if [ "$code" = "0" ] && [ ! "$recordId" = "$result" ]; then
		local ip=$(echo $result | sed 's/.*\,"value":"\([0-9\.]*\)".*/\1/')

		if [ "$ip" = "$NewIP" ]; then
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
	local result=$(sendRequest "RecordModify" "domain=$Domain&recordId=$1&recordLine=默认&recordType=A&subDomain=$SubDomain&value=$2")
	local code=$(echo $result | sed 's/.*{"code":\([0-9]*\),.*/\1/')
	
	if [ "$code" = "0" ] && [ ! "$recordId" = "$result" ]; then
		echo "$SubDomain.$Domain 已指向 $NewIP." >&2
	else
		echo "更新失败." >&2
		echo $result >&2
	fi
}

# $1 = new IP
addRecord() {
	local result=$(sendRequest "RecordCreate" "domain=$Domain&recordLine=默认&recordType=A&subDomain=$SubDomain&value=$1")
	local code=$(echo $result | sed 's/.*{"code":\([0-9]*\),.*/\1/')

	if [ "$code" = "0" ] && [ ! "$recordId" = "$result" ]; then
		echo "$SubDomain.$Domain 已指向 $NewIP." >&2
	else
		echo "添加失败." >&2
		echo $result >&2
	fi
}

# Get new IP address
echo "获取当前IP..."
NewIP=$(wget -qO- --no-check-certificate http://members.3322.org/dyndns/getip)
echo "当前 IP 为 $NewIP."

# Get record ID of sub domain
RecordId=$(getRecordId)

if [ ! "$RecordId" = "quit" ]; then
	if [ "$RecordId" = "null" ]; then
		echo "域名记录不存在, 添加 $SubDomain.$Domain 至 $NewIP..."
		RecordId=$(addRecord $NewIP)
	else
		echo "域名记录已存在, 更新 $SubDomain.$Domain 至 $NewIP..."
		RecordId=$(updateRecord $RecordId $NewIP)
	fi
fi