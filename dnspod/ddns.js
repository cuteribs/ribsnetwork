#!/usr/bin/env node
const fs = require('fs');
const request = require('request');
const crypto = require('crypto');

const args = process.argv.slice(2);
const envs = process.env;

var loginToken, domain, subDomain, lastIPFile, lastIP, newIP, result, code, message;

loginToken = envs['LoginToken'] == undefined ? args[0] : envs['LoginToken'];
domain = envs['Domain'] == undefined ? args[1] : envs['Domain'];
subDomain = envs['SubDomain'] == undefined ? args[2] : envs['SubDomain'];

if (typeof (loginToken) != 'string' || typeof (loginToken) != 'string' || typeof (loginToken) != 'string') {
	console.error('invalid parameter.')
	process.exit(1);
}

if (subDomain.trim().length == 0) {
	subDomain = '@';
}


var getLastIP = function () {
	let file = '/tmp/lastIPFile';
	let ip;

	if (fs.existsSync(file)) {
		ip = fs.readFileSync(file);
		console.log('Last IP $LastIP is found.');
	}

	return ip;
};

// Get new IP
console.log('Retreiving current IP...');
request.post('http://members.3322.org/dyndns/getip', (err, res, body) => { });

/*
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
		exit 1
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
		exit 1
	fi	
fi

echo "$NewIP" > $LastIPFile

*/