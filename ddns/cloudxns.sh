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

ApiRequestDate=$(date)

# $1 = query string
getSignature() {
	local message="$ApiId$1$2$ApiRequestDate$ApiKey"
	local sig=$(echo -n "$message" | openssl md5 | awk '{print $2}')
	echo $sig
}

sendRequest() {
	local sig=$(getSignature "https://www.cloudxns.net/api2/ddns" $1)
	local result=$(wget -qO- --no-check-certificate --header="API-KEY: $ApiId" --header="API-REQUEST-DATE: $ApiRequestDate" --header="API-HMAC: $sig" --post-data "$1" "https://www.cloudxns.net/api2/ddns")
	echo $result
}

updateDDNS() {
	echo "更新 $SubDomain.$Domain 的 IP..."
	local result=$(sendRequest "{\"domain\":\"$SubDomain.$Domain.\"}")
	local code=$(echo $result | sed 's/.*{"code":\([0-9]*\),.*/\1/')

	if [ "$code" = "1" ]; then
		echo "更新完成." >&2
	else
		echo "更新出错." >&2
		echo $result >&2
	fi
}

updateDDNS
