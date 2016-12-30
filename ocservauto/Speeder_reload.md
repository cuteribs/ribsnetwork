使用说明
=====================
这是个锐速加速脚本。

前提是锐速开启并且加速默认的出口网卡，例如eth0。如果不清楚，可以用下面命令得知
```
ip route show|sed -n 's/^default.* dev \([^ ]*\).*/\1/p'
```
编辑/etc/ocserv/ocserv.conf,取消ocserv.conf中下面一行的注释并修改为
```
connect-script = /etc/ocserv/Speeder_reload.sh
#disconnect-script = /etc/ocserv/Speeder_reload.sh
```
然后下载脚本，并加上可执行权限
```
wget https://raw.githubusercontent.com/fanyueciyuan/eazy-for-ss/master/ocservauto/Speeder_reload.sh -O /etc/ocserv/Speeder_reload.sh
chmod +x /etc/ocserv/Speeder_reload.sh
```
重启一下ocserv
```
/etc/init.d/ocserv restart
```

From https://www.v2ex.com/t/172292
