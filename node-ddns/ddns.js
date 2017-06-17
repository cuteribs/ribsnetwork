#!/usr/bin/env node
const schedule = require('node-schedule');
const { fork } = require('child_process');

var time = process.env['ScheduleTime'] || '* 6 * * *';
var vendor = process.argv[2];
var params = process.argv.slice(3);

console.log(`Initial DDNS request of ${vendor} is launched.`);
console.log('------------------------------------------------------------')
fork(`./${vendor}.js`, params)
	.on('error', () => process.exit(1))
	.on('close', () => {
		console.log('------------------------------------------------------------');
		console.log(`Initial DDNS request of ${vendor} is finished.`);
	});
schedule.scheduleJob('syncDDNS', time, () => {
	console.log(`Scheduled DDNS request of ${vendor} is launched.`);
	console.log('------------------------------------------------------------')
	fork(`./${vendor}.js`, params)
		.on('error', () => process.exit(1))
		.on('close', () => {
			console.log('------------------------------------------------------------');
			console.log(`Scheduled DDNS request of ${vendor} is finished.`);
		});
});