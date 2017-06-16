#!/usr/bin/env node
const Promise = require('promise');
const fs = require('fs');
const request = require('request');

const args = process.argv.slice(2);

var loginToken, domain, subDomain, lastIPFile, newIP;

var main = () => {
	lastIPFile = process.platform == 'win32' ? process.env['TEMP'] + '\lastIPFile' : '/tmp/lastIPFile';
	loginToken = args[0];
	domain = args[1];
	subDomain = args[2];

	if (typeof (loginToken) != 'string' || typeof (domain) != 'string' || typeof (subDomain) != 'string') {
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
		let code = result.status.code;

		if (code == '1') {
			let recordId = result.records[0].id;
			console.log(`Record ID ${recordId} exists.`);
			return updateRecord(recordId);
		} else if (code == '10') {
			console.log(`Record ID does not exist.`);
			return createRecord();
		}

		console.log(result.status.message);
		process.exit(1);
	}, reason => console.log(reason)).then(result => {
		let code = result.status.code;

		if (code == '1') {
			console.log(`${subDomain}.${domain} is now pointed to ${newIP}`);
			return updateLastIP();
		}

		console.log(`Failed to update IP of ${subDomain}.${domain}.`);
		console.log(result.status.message);
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

var getRecordId = () => {
	return new Promise((resolve, reject) => {
		console.log(`Retreiving the record ID of ${subDomain}.${domain}...`);

		request.post('https://dnsapi.cn/Record.List', {
			form: {
				'format': 'json',
				'login_token': loginToken,
				'domain': domain,
				'sub_domain': subDomain
			}
		}, (err, res, body) => resolve(JSON.parse(body)));
	});
};

var updateRecord = (recordId) => {
	return new Promise((resolve, reject) => {
		console.log(`Pointing ${subDomain}.${domain} to ${newIP}...`);

		request.post('https://dnsapi.cn/Record.Modify', {
			form: {
				'format': 'json',
				'login_token': loginToken,
				'domain': domain,
				'sub_domain': subDomain,
				'record_id': recordId,
				'record_type': 'A',
				'record_line_id': 0,
				'value': newIP
			}
		}, (err, res, body) => resolve(JSON.parse(body)));

	});
};

var createRecord = () => {
	return new Promise((resolve, reject) => {
		console.log(`Pointing ${subDomain}.${domain} to ${newIP}...`);

		request.post('https://dnsapi.cn/Record.Create', {
			form: {
				'format': 'json',
				'login_token': loginToken,
				'domain': domain,
				'sub_domain': subDomain,
				'record_type': 'A',
				'record_line_id': 0,
				'value': newIP
			}
		}, (err, res, body) => resolve(JSON.parse(body)));
	});
};

main();