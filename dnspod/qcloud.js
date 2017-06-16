#!/usr/bin/env node
const Promise = require('promise');
const fs = require('fs');
const request = require('request');
const crypto = require('crypto');
const querystring = require('querystring');

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

	Promise.all([getNewIP(), getLastIP()]).then(ips => {
		if (ips[0] == ips[1]) {
			console.log('No IP change, quiting the script...');
			process.exit();
		} else {
			newIP = ips[0];
			return getRecordId();
		}
	}, reason => console.log(reason)).then(result => {
		if (result.code == 0) {
			let recordId = result.data.records.length == 1 ? result.data.records[0].id : undefined;

			if (recordId) {
				console.log(`Record ID ${recordId} exists.`);
				return updateRecord(recordId);
			} else {
				console.log(`Record ID does not exist.`);
				return createRecord();
			}
		}

		console.log(result.message);
		process.exit(1);
	}, reason => console.log(reason)).then(result => {
		console.log(result);
		if (result.code == 0) {
			console.log(`${subDomain}.${domain} is now pointed to ${newIP}`);
			return updateLastIP();
		}

		console.log(`Failed to update IP of ${subDomain}.${domain}.`);
		console.log(result.message);
		process.exit(1);
	}, reason => console.log(reason));
};

var getNewIP = () => {
	return new Promise((resolve, reject) => {
		console.log('Retreiving current IP...');
		request.post('http://members.3322.org/dyndns/getip', (err, res, body) => resolve(body.trim()));
	});
};

var getLastIP = () => {
	return new Promise((resolve, reject) => {
		let ip;

		if (fs.existsSync(lastIPFile)) {
			ip = fs.readFileSync(lastIPFile, 'utf8');
			console.log(`Last IP ${ip} is found.`);
		}

		// resolve(ip);
		resolve();
	});
};

var updateLastIP = () => {
	return new Promise((resolve, reject) => {
		fs.writeFileSync(lastIPFile, newIP, 'utf8');
		console.log(`${newIP} is saved to ${lastIPFile}.`)
		resolve();
	});
};

var getSignature = (queryString) => {
	let message = 'GETcns.api.qcloud.com/v2/index.php?' + queryString;
	let hash = crypto.createHmac('sha256', secretKey).update(message).digest('base64'); console.log(hash);
	return encodeURIComponent(hash);
};

var sendRequest = (action, otherParams, resolve, reject) => {
	let nonce = Math.round(Math.random() * 65535);
	let timestamp = Math.round(Date.now() / 1000);
	let commonParams = {
		'Action': action,
		'Nonce': nonce,
		'Region': 'sh',
		'SecretId': secretId,
		'SignatureMethod': 'HmacSHA256',
		'Timestamp': timestamp
	};

	let query = Object.assign(commonParams, otherParams);
	let signature = getSignature(querystring.stringify(query));

	// SB 腾讯中文数据处理有问题!!!
	if (otherParams.recordLine) {
		otherParams.recordLine = encodeURIComponent(otherParams.recordLine);
	}

	query = Object.assign(commonParams, otherParams);
	url = `https://cns.api.qcloud.com/v2/index.php?Signature=${signature}&` + querystring.stringify(query);
	console.log(url);

	request.get(url, (err, res, body) => {
		if (err) {
			reject(err);
		} else {
			resolve(JSON.parse(body));
		}
	});
};

var getRecordId = () => {
	return new Promise((resolve, reject) => {
		console.log(`Retreiving the record ID of ${subDomain}.${domain}...`);
		let params = {
			'domain': domain,
			'recordType': 'A',
			'subDomain': subDomain
		};
		sendRequest('RecordList', params, resolve, reject);
	});
};

var updateRecord = (recordId) => {
	return new Promise((resolve, reject) => {
		console.log(`Updating ${subDomain}.${domain} to ${newIP}...`);
		let params = {
			'domain': domain,
			'recordId': recordId,
			'recordLine': '默认',
			'recordType': 'A',
			'subDomain': subDomain,
			'value': newIP
		};
		sendRequest('RecordModify', params, resolve, reject);
	});
};

var createRecord = () => {
	return new Promise((resolve, reject) => {
		console.log(`Creating ${subDomain}.${domain} to ${newIP}...`);
		let params = {
			'domain': domain,
			'recordLine': '默认',
			'recordType': 'A',
			'subDomain': subDomain,
			'value': newIP
		};
		sendRequest('RecordCreate', params, resolve, reject);
	});
};

main();