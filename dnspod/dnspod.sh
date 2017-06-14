#!/bin/sh

if [ $1 ]; then
	LoginToken=$1
fi

if [ $2 ]; then
	Domain=$2
fi

if [ $3 ]; then
	SubDomain=$3
fi

if [ -z "$SubDomain" ]; then
	SubDomain="@"
fi

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
Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain" https://dnsapi.cn/Record.List)
Code=$(echo $Result | jq -r '.status.code')

if [ "$Code" = "1" ]; then
	RecordId=$(echo $Result | jq -r '.records[0].id')
	echo "Record ID $RecordId exists."
	echo "Pointing $SubDomain.$Domain to $NewIP..."
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&record_id=$RecordId&record_type=A&record_line_id=0&sub_domain=$SubDomain&value=$NewIP" https://dnsapi.cn/Record.Modify)
	Code=$(echo $Result | jq -r '.status.code')

	if [ "$Code" = "1" ]; then
		echo "$SubDomain.$Domain is now pointed to $NewIP."
	else
		echo "Failed to update IP of $SubDomain.$Domain."
		echo $Result | jq -r '.status.message'
		exit -1
	fi	
else
	echo "Record ID does not exist."
	echo "Pointing $SubDomain.$Domain to $NewIP..."
	Result=$(wget -qO- --no-check-certificate --post-data "login_token=$LoginToken&format=json&domain=$Domain&sub_domain=$SubDomain&record_type=A&record_line_id=0&value=$NewIP" https://dnsapi.cn/Record.Create)
	Code=$(echo $Result | jq -r '.status.code')

	if [ "$Code" = "1" ]; then
		echo "$SubDomain.$Domain => $NewIP, IP updated."
	else
		echo "Failed to update IP of $SubDomain.$Domain."
		echo $Result | jq -r '.status.message'
		exit -1
	fi	
fi

echo "$NewIP" > $LastIPFile