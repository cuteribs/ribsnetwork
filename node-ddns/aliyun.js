#!/usr/bin/env node
const Promise = require('promise');
const fs = require('fs');
const request = require('request');
const crypto = require('crypto');

const args = process.argv.slice(2);

var accessKeyId, accessKeySecret, domainName, subDomain, newIP;

var main = () => {
	accessKeyId = args[0];
	accessKeySecret = args[1];
	domainName = args[2];
	subDomain = args[3];

	if (typeof (accessKeyId) != 'string' || typeof (accessKeySecret) != 'string' || typeof (domainName) != 'string' || typeof (subDomain) != 'string') {
		console.error('invalid parameter.')
		process.exit(1);
	}

	getNewIP().then(() => getRecordId(), reason => console.log(reason))
		.then(result => {
			if (result.Code) {
				console.log(result.Message);
				process.exit(1);
			} else if (result.DomainRecords.Record.length > 0) {
				let ip = result.DomainRecords.Record[0].Value;

				if (ip == newIP) {
					console.log('IP remains the same, quiting the script...');
					process.exit();
				}

				let recordId = result.DomainRecords.Record[0].RecordId;
				console.log(`Record ID ${recordId} exists.`);
				return updateRecord(recordId);
			} else {
				console.log(`Record ID does not exist.`);
				return createRecord();
			}
		}, reason => console.log(reason))
		.then(result => {
			if (result.Code) {
				console.log(`Failed to update IP of ${subDomain}.${domainName}.`);
				console.log(result);
				process.exit(1);
			} else {
				console.log(`${subDomain}.${domainName} is now pointed to ${newIP}`);
				return updateLastIP();
			}
		}, reason => console.log(reason));
};

var getNewIP = () => {
	return new Promise((resolve, reject) => {
		console.log('Retreiving current IP...');
		request.post('http://members.3322.org/dyndns/getip', (err, res, body) => {
			newIP = body.trim();
			console.log(`Current IP is ${newIP}`)
			resolve();
		});
	});
};

var getLastIP = () => {
	return new Promise((resolve, reject) => {
		let ip;

		if (fs.existsSync(lastIPFile)) {
			ip = fs.readFileSync(lastIPFile, 'utf8');
			console.log(`Last IP ${ip} is found.`);
		}

		resolve(ip);
	});
};

var updateLastIP = () => {
	return new Promise((resolve, reject) => {
		fs.writeFileSync(lastIPFile, newIP, 'utf8');
		console.log(`${newIP} is saved to ${lastIPFile}.`)
		resolve();
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

var getSignature = (params) => {
	let message = 'GET&%2F&' + encodeURIComponent(objectToQueryString(params));
	let hash = crypto.createHmac('sha1', accessKeySecret + '&').update(message).digest('base64');
	return encodeURIComponent(hash);
};

var getTimestamp = () => {
	let timestamp = new Date().toISOString().substr(0, 19) + 'Z';
	return timestamp;
};

var combineSort = (...objs) => {
	let newObj = {};

	objs.forEach(o => Object.assign(newObj, o));
	let keys = [];
	let sortedObj = {};

	for (let k in newObj) {
		keys.push(k);
	}

	keys.sort();

	for (let i = 0; i < keys.length; i++) {
		sortedObj[keys[i]] = newObj[keys[i]];
	}

	return sortedObj;
};

var sendRequest = (otherParams, resolve, reject) => {
	let nonce = Math.round(Math.random() * 65535);
	let timestamp = getTimestamp();
	let commonParams = {
		'AccessKeyId': accessKeyId,
		'DomainName': domainName,
		'Format': 'JSON',
		'SignatureMethod': 'HMAC-SHA1',
		'SignatureNonce': nonce,
		'SignatureVersion': '1.0',
		'Timestamp': timestamp,
		'Version': '2015-01-09'
	};

	let params = combineSort(commonParams, otherParams);
	let signature = getSignature(params);
	let query = objectToQueryString(params);
	let url = `https://alidns.aliyuncs.com?${query}&Signature=${signature}`;

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
		console.log(`Retreiving the record ID of ${subDomain}.${domainName}...`);

		let params = {
			'Action': 'DescribeDomainRecords',
			'DomainName': domainName,
			'TypeKeyWord': 'A',
			'RRKeyWord': subDomain
		};
		sendRequest(params, resolve, reject);
	});
};

var updateRecord = (recordId) => {
	return new Promise((resolve, reject) => {
		console.log(`Updating ${subDomain}.${domainName} to ${newIP}...`);
		let params = {
			'Action': 'UpdateDomainRecord',
			'DomainName': domainName,
			'RecordId': recordId,
			'Type': 'A',
			'RR': subDomain,
			'Value': newIP
		};
		sendRequest(params, resolve, reject);
	});
};

var createRecord = () => {
	return new Promise((resolve, reject) => {
		console.log(`Creating ${subDomain}.${domainName} to ${newIP}...`);
		let params = {
			'Action': 'AddDomainRecord',
			'DomainName': domainName,
			'Type': 'A',
			'RR': subDomain,
			'Value': newIP
		};
		sendRequest(params, resolve, reject);
	});
};

main();