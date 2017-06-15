#!/usr/bin/env node
const https = require('https');
const crypto = require('crypto');

const args = process.argv.slice(2);
const envs = process.env;

var loginToken, domain, subDomain;

loginToken = envs['LoginToken'] == undefined ? args[0] : envs['LoginToken'];
domain = envs['Domain'] == undefined ? args[1] : envs['Domain'];
subDomain = envs['SubDomain'] == undefined ? args[2] : envs['SubDomain'];

if(typeof(loginToken) != 'string' || typeof(loginToken) != 'string' || typeof(loginToken) != 'string'){
	console.error('invalid parameter.')
	process.exit(1);
}

if(subDomain.trim().length == 0) {
	subDomain = '@';
}

if(env)
var secretKey = process.env['SecretKey'];

if(typeof(secretKey) != 'string') {
	secretKey = 'Gu5t9xGARNpq86cd98joQYCN3Cozk1qA';
}

var hmac = crypto.createHmac('sha256', secretKey);

hmac.update('GETcvm.api.qcloud.com/v2/index.php?Action=DescribeInstances&Nonce=11886&Region=gz&SecretId=AKIDz8krbsJ5yKBZQpn74WFkmLPx3gnPhESA&SignatureMethod=HmacSHA256&Timestamp=1465185768&instanceIds.0=ins-09dx96dg&limit=20&offset=0');
console.log(hmac.digest('base64'));