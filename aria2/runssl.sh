#!/bin/sh

nohup aria2c --dir=/data/download --enable-rpc --rpc-listen-all --rpc-listen-port=6800 --rpc-private-key=/data/crt/ssl.key --rpc-certificate=/data/crt/ssl.crt --rpc-secure --rpc-secret=$Secret &

lighttpd -D -f /data/conf/https.conf