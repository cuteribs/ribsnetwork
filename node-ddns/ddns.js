#!/usr/bin/env node
const { fork } = require('child_process');

var vender = process.argv[2];
var params = process.argv.slice(3);

var child = fork(`./${vender}.js`, params);