#!/usr/bin/env node
const Capi = require('qcloudapi-sdk');

const args = process.argv.slice(2);

var secretId, secretKey, domain, subDomain, lastIPFile, newIP;

var main = () => {
	lastIPFile = process.platform == 'win32' ? process.env['TEMP'] + '\lastIPFile' : '/tmp/lastIPFile';
	secretId = args[0];
	secretKey = args[1];
	domain = args[2];
	subDomain = args[3];

	if (typeof (secretId) != 'string' || typeof (secretKey) != 'string' || typeof (domain) != 'string' || typeof (subDomain) != 'string') {
		console.error('invalid parameter.')
		process.exit(1);
	}

	let capi = new Capi({
		SecretId: secretId,
		SecretKey: secretKey,
		serviceType: 'cns',
		method: 'GET'
	});

	capi.request({
		Region: 'sh',
		Action: 'RecordList',
		'domain': domain,
		'recordType': 'A',
		'subDomain': subDomain,
		'SignatureMethod': 'HmacSHA256',
		// 'recordId':303862422,
		// 'recordLine':'默认',
		// 'value':'124.78.63.209'
	}, (err, data) => console.log(data));

};


main();