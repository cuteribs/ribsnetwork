#!/usr/bin/env node
const Promise = require('promise');
const fs = require('fs');
const request = require('request');
const crypto = require('crypto');

const args = process.argv.slice(2);

var secretId, secretKey, domain, subDomain, newIP;

var main = () => {
	secretId = args[0];
	secretKey = args[1];
	domain = args[2];
	subDomain = args[3];

	if (typeof (secretId) != 'string' || typeof (secretKey) != 'string' || typeof (domain) != 'string' || typeof (subDomain) != 'string') {
		console.error('invalid parameter.')
		process.exit(1);
	}

	getNewIP().then(() => getRecordId(), reason => console.log(reason))
		.then(result => {
			if (result.code == 0) {
				if (result.data.records.length > 0) {
					let ip = result.data.records[0].value;

					if (ip == newIP) {
						console.log('IP remains the same, quiting the script...');
						process.exit();
					}

					let recordId = result.data.records[0].id;
					console.log(`Record ID ${recordId} exists.`);
					return updateRecord(recordId);
				} else {
					console.log(`Record ID does not exist.`);
					return createRecord();
				}
			} else {
				console.log(result.message);
				process.exit(1);
			}
		}, reason => console.log(reason))
		.then(result => {
			if (result.code == 0) {
				console.log(`${subDomain}.${domain} is now pointed to ${newIP}`);
			}
			else {
				console.log(`Failed to update IP of ${subDomain}.${domain}.`);
				console.log(result);
				process.exit(1);
			}
		}, reason => console.log(reason));
};

var getNewIP = () => {
	return new Promise((resolve, reject) => {
		console.log('Retreiving current IP...');
		request.post('http://members.3322.org/dyndns/getip', (err, res, body) => {
			newIP = body.trim();
			console.log(`Current IP is ${newIP}`);
			resolve();
		});
	});
};

var objectToQueryString = (obj, encode = true) => {
	let params = [];

	for (let k in obj) {
		if (encode) {
			params.push(k + '=' + encodeURIComponent(obj[k]));
		} else {
			params.push(k + '=' + obj[k]);
		}
	}

	return params.join('&');
};

var getSignature = (queryString) => {
	let message = 'GETcns.api.qcloud.com/v2/index.php?' + queryString;
	let hash = crypto.createHmac('sha256', secretKey).update(message).digest('base64');
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

	let query = Object.assign({}, commonParams, otherParams);
	let signature = getSignature(objectToQueryString(query, false));	//中文数据不能encode

	query = Object.assign({}, commonParams, otherParams);
	url = `https://cns.api.qcloud.com/v2/index.php?` + objectToQueryString(query) + `&Signature=${signature}`;

	request.get(url, { json: true, strictSSL: false }, (err, res, body) => {
		if (err) {
			reject(err);
		} else {
			resolve(body);
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