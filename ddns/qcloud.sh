#!/bin/sh

if [ $1 ]; then
	SecretId=$1
fi

if [ $2 ]; then
	SecretKey=$2
fi

if [ $3 ]; then
	Domain=$3
fi

if [ $4 ]; then
	SubDomain=$4
fi

if [ -z "$SubDomain" ]; then
	SubDomain="@"
fi

ErrorMessage=""

# $1 = query string
getSignature() {
	Message="GETcns.api.qcloud.com/v2/index.php?$1"
	Sig=$(echo -n "$Message" | openssl dgst -sha256 -hmac "$SecretKey" -binary | openssl base64)
	Sig=$(echo $Sig | sed 's:+:%2B:g')
	Sig=$(echo $Sig | sed 's:/:%2F:g')
	Sig=$(echo $Sig | sed 's:=:%3D:g')
	echo $Sig
}

sendRequest() {
	Nonce=$RANDOM
	Timestamp=$(date '+%s')
	QueryString="Action=$1&Nonce=$Nonce&Region=sh&SecretId=$SecretId&SignatureMethod=HmacSHA256&Timestamp=$Timestamp&$2"
	Signature=$(getSignature $QueryString)
	Result=$(wget -qO- --no-check-certificate "https://cns.api.qcloud.com/v2/index.php?$QueryString&Signature=$Signature")
	echo $Result
}

getRecordId() {	
	Result=$(sendRequest "RecordList" "domain=$Domain&recordType=A&subDomain=$SubDomain")
	Code=$(echo $Result | jq -r '.code')
	
	if [ "$Code" = "0" ]; then
		RecordId=$(echo $Result | jq -r '.data.records[0].id')
		echo $RecordId
	else
		ErrorMessage=$(echo $Result | jq -r '.message')
		echo "null"
	fi
}

# $1 = record ID, $2 = new IP
updateRecord() {
	Result=$(sendRequest "RecordModify" "domain=$Domain&recordId=$1&recordLine=默认&recordType=A&subDomain=$SubDomain&value=$2")
	Code=$(echo $Result | jq -r '.code')
	
	if [ "$Code" = "0" ]; then
		RecordId=$(echo $Result | jq -r '.data.record.id')
		echo $RecordId
	else
		ErrorMessage=$(echo $Result | jq -r '.message')
		echo "null"
	fi
}

# $1 = new IP
addRecord() {
	Result=$(sendRequest "RecordCreate" "domain=$Domain&recordLine=默认&recordType=A&subDomain=$SubDomain&value=$1")
	Code=$(echo $Result | jq -r '.code')
	
	if [ "$Code" = "0" ]; then
		RecordId=$(echo $Result | jq -r '.data.record.id')
		echo $RecordId
	else
		ErrorMessage=$(echo $Result | jq -r '.message')
		echo "null"
	fi
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
RecordId=$(getRecordId)

if [ "$RecordId" = "null" ]; then
	echo "Record ID does not exist."
	echo "Pointing $SubDomain.$Domain to $NewIP..."
	RecordId=$(addRecord $NewIP)
else
	echo "Record ID $RecordId exists."
	echo "Pointing $SubDomain.$Domain to $NewIP..."
	RecordId=$(updateRecord $RecordId $NewIP)
fi
	
if [ "$RecordId" = "null" ]; then
	echo "Failed to update IP of $SubDomain.$Domain."
	echo $ErrorMessage
else
	echo "$SubDomain.$Domain => $NewIP, IP updated."
	echo "$NewIP" > $LastIPFile
fi
