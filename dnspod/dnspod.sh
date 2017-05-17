#!/bin/bash
NewIP=$(curl http://members.3322.org/dyndns/getip 2>/dev/null)
Data="login_token=$Token&format=json&domain=$Domain&record_id=$RecordId&record_line_id=$RecordLineId&sub_domain=$SubDomain&value=$NewIP"
curl -X POST https://dnsapi.cn/Record.Ddns -d ${Data} >> ~/cron.log 2>&1
