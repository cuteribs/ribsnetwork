#!/bin/sh

nohup aria2c --dir=/data/download --enable-rpc --rpc-listen-all --rpc-listen-port=6800 --rpc-secret=$Secret &

lighttpd -D -f /data/conf/http.conf