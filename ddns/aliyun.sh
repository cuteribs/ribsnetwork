#!/bin/sh

if [ $1 ]; then
	AccessKeyId=$1
fi

if [ $2 ]; then
	AccessKeySecret=$2
fi

if [ $3 ]; then
	DomainName=$3
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
echo $Timestamp

urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

# $1 = query string
getSignature() {
	local encodedQuery=$(urlencode $1)
	local message="GET&%2F&$encodedQuery"
	echo "message=$message" >&2
	local sig=$(echo -n "$message" | openssl dgst -sha1 -hmac "$AccessKeySecret&" -binary | openssl base64)
	echo $(urlencode $sig)
}

sendRequest() {
	local sig=$(getSignature $1)
	local result=$(curl -s "https://alidns.aliyuncs.com?$1&Signature=$sig")
	echo "url=https://alidns.aliyuncs.com?$1&Signature=$sig" >&2
	echo $result
}

getRecordId() {
	local queryString="AccessKeyId=$AccessKeyId&Action=DescribeDomainRecords&DomainName=$DomainName&Format=JSON&RRKeyWord=$SubDomain&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&Timestamp=$Timestamp&TypeKeyWord=A&Version=2015-01-09"
	local result=$(sendRequest "$queryString")
	local code=$(echo $result | jq -r '.Code')
	
	if [ "$code" = "null" ]; then
		local ip=$(echo $result | jq -r '.DomainRecords.Record[0].Value')

		if [ "$ip" == "$NewIP" ]; then
			echo "IP remains the same, quiting the script..."
			exit 0
		fi

		local recordId=$(echo $result | jq -r '.DomainRecords.Record[0].RecordId')
		echo $recordId
	else
		echo $(echo $result | jq -r '.Message') >&2
		exit 1
	fi
}

# $1 = record ID, $2 = new IP
updateRecord() {
	local queryString="AccessKeyId=$AccessKeyId&Action=UpdateDomainRecord&DomainName=$DomainName&Format=JSON&RR=$SubDomain&RecordId=$1&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&Timestamp=$Timestamp&Type=A&Value=$2&Version=2015-01-09"
	local result=$(sendRequest $queryString)
	local code=$(echo $result | jq -r '.Code')
	
	if [ "$code" = "null" ]; then
		local recordId=$(echo $result | jq -r '.RecordId')
		echo $recordId
	else
		echo $(echo $result | jq -r '.Message') >&2
		exit 1
		echo "123" >&2
	fi
}

# $1 = new IP
addRecord() {
	local queryString="AccessKeyId=$AccessKeyId&Action=AddDomainRecord&DomainName=$DomainName&Format=JSON&RR=$SubDomain&SignatureMethod=HMAC-SHA1&SignatureNonce=$Nonce&SignatureVersion=1.0&Timestamp=$Timestamp&Type=A&Value=$1&Version=2015-01-09"
	local result=$(sendRequest $queryString)
	local code=$(echo $result | jq -r '.Code')

	if [ "$code" = "null" ]; then
		local recordId=$(echo $result | jq -r '.RecordId')
		echo $recordId
	else
		echo $(echo $result | jq -r '.Message') >&2
		echo "null"
	fi
}

# Get new IP address
echo "Retreiving current IP..."
NewIP=$(curl -s http://members.3322.org/dyndns/getip)
echo "Current IP is $NewIP."

# Get record ID of sub domain
echo "Retreiving the record of $SubDomain.$DomainName..."
recordId=$(getRecordId)
echo $recordId

if [ "$recordId" = "null" ]; then
	echo "Record ID does not exist."
	echo "Creating $SubDomain.$DomainName to $NewIP..."
	recordId=$(addRecord $NewIP)
else
	echo "Record ID $recordId exists."
	echo "Updating $SubDomain.$DomainName to $NewIP..."
	recordId=$(updateRecord $recordId $NewIP)
fi
	
if [ "$recordId" = "null" ]; then
	echo "Failed to update IP of $SubDomain.$DomainName."
	echo "error=$ErrorMessage"
else
	echo "$SubDomain.$DomainName => $NewIP, IP updated."
fi
