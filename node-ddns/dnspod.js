#!/usr/bin/env node
const Promise = require('promise');
const fs = require('fs');
const request = require('request');

const args = process.argv.slice(2);

var loginToken, domain, subDomain, newIP;

var main = () => {
	loginToken = args[0];
	domain = args[1];
	subDomain = args[2];

	if (typeof (loginToken) != 'string' || typeof (domain) != 'string' || typeof (subDomain) != 'string') {
		console.error('invalid parameter.')
		process.exit(1);
	}

	getNewIP().then(() => getRecordId(), reason => console.log(reason))
		.then(result => {
			let code = result.status.code;

			if (code == '1') {
				let ip = result.records[0].value;

				if (ip == newIP) {
					console.log('IP remains the same, quiting the script...');
					process.exit();
				}

				let recordId = result.records[0].id;
				console.log(`Record ID ${recordId} exists.`);
				return updateRecord(recordId);
			} else if (code == '10') {
				console.log(`Record ID does not exist.`);
				return createRecord();
			}

			console.log(result.status.message);
			process.exit(1);
		}, reason => console.log(reason))
		.then(result => {
			let code = result.status.code;

			if (code == '1') {
				console.log(`${subDomain}.${domain} is now pointed to ${newIP}`);
			} else {
				console.log(`Failed to update IP of ${subDomain}.${domain}.`);
				console.log(result.status.message);
				process.exit(1);
			}
		}, reason => console.log(reason));
};

var getNewIP = () => {
	return new Promise((resolve, reject) => {
		console.log('Retreiving current IP...');
		request.post('http://members.3322.org/dyndns/getip', (err, res, body) => {
			newIP = body.trim();
			resolve();
		});
	});
};

var sendRequest = (action, params, resolve, reject) => {
	request.post(`https://dnsapi.cn/${action}`, { json: true, strictSSL: false, form: params }, (err, res, body) => {
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
			'format': 'json',
			'login_token': loginToken,
			'domain': domain,
			'sub_domain': subDomain
		};
		sendRequest('Record.List', params, resolve, reject);
	});
};

var updateRecord = (recordId) => {
	return new Promise((resolve, reject) => {
		console.log(`Updating ${subDomain}.${domain} to ${newIP}...`);
		let params = {
			'format': 'json',
			'login_token': loginToken,
			'domain': domain,
			'sub_domain': subDomain,
			'record_id': recordId,
			'record_type': 'A',
			'record_line_id': 0,
			'value': newIP
		};
		sendRequest('Record.Modify', params, resolve, reject);
	});
};

var createRecord = () => {
	return new Promise((resolve, reject) => {
		console.log(`Creating ${subDomain}.${domain} to ${newIP}...`);
		let params = {
			'format': 'json',
			'login_token': loginToken,
			'domain': domain,
			'sub_domain': subDomain,
			'record_type': 'A',
			'record_line_id': 0,
			'value': newIP
		};
		sendRequest('Record.Create', params, resolve, reject);
	});
};

main();