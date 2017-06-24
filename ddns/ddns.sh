#!/bin/sh

set -e

touch /app/cron.log
echo "$Time sh /app/$Script.sh" > /app/cron.conf
sh "/app/$Script.sh" && crontab /app/cron.conf && tail -f /app/cron.log
