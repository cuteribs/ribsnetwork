#!/bin/sh

set -e

if [ $1 ]; then
	ApiKey=$1
fi

if [ $2 ]; then
	SecretKey=$2
fi

if [ $3 ]; then
	Domain=$3
fi

if [ -z "$ApiKey" -o -z "$SecretKey" -o -z "$Domain" ]; then
	echo "Missing parameters"
	exit 1
fi

if [ $4 ]; then
	Host=$4
fi

if [ -z "$Host" ]; then
	Host="@"
fi

ApiRequestDate=$(date)

# $1 = query string
getSignature() {
	local message="$ApiKey$1$2$ApiRequestDate$SecretKey"
	local sig=$(echo -n "$message" | openssl md5 | awk '{print $2}')
	echo $sig
}

sendRequest() {
	local sig=$(getSignature "https://www.cloudxns.net/api2/ddns" $1)
	local result=$(wget -qO- --no-check-certificate --header="API-KEY: $ApiKey" --header="API-REQUEST-DATE: $ApiRequestDate" --header="API-HMAC: $sig" --post-data "$1" "https://www.cloudxns.net/api2/ddns")
	echo $result
}

updateDDNS() {
	echo "Updating $Host.$Domain to $NewIP..."
	local result=$(sendRequest "{\"domain\":\"$Host.$Domain.\",\"ip\":\"$NewIP\"}")
	local code=$(echo $result | jq -r '.code')

	if [ "$code" = "1" ]; then
		echo "$Host.$Domain => $NewIP, IP updated." >&2
	else
		local message=$(echo $result | jq -r '.message')
		echo "$message" >&2
		exit 1
	fi
}

# Get new IP address
echo "Retreiving current IP..."
NewIP=$(wget -qO- --no-check-certificate http://members.3322.org/dyndns/getip)
echo "Current IP $NewIP is retrieved."

updateDDNS
