#!/bin/bash
NET_OC_CONF_DOC="https://raw.githubusercontent.com/fanyueciyuan/eazy-for-ss/master/ocservauto"
rm -f ocservauto.sh
wget -c --no-check-certificate http://git.io/p9r8 -O ocservauto.sh
[ ! -d /etc/ocserv ] && mkdir /etc/ocserv 
cd /etc/ocserv
[  -f /etc/init.d/ocserv ] && rm -f /etc/init.d/ocserv
[  -f ocserv-up.sh ] && rm -f ocserv-up.sh
[  -f ocserv-down.sh ] && rm -f ocserv-down.sh
wget -c --no-check-certificate $NET_OC_CONF_DOC/ocserv -O /etc/init.d/ocserv
chmod 755 /etc/init.d/ocserv
pgrep systemd-journal > /dev/null 2>&1 && systemctl daemon-reload > /dev/null 2>&1
wget -c --no-check-certificate $NET_OC_CONF_DOC/ocserv-up.sh
chmod +x ocserv-up.sh
wget -c --no-check-certificate $NET_OC_CONF_DOC/ocserv-down.sh
chmod +x ocserv-down.sh
/etc/init.d/ocserv restart
