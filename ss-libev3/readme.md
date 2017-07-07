### SS Server
```
docker run -d \
--name ss-server1 \
-p 181:8080 \
-p 181:8080/udp \
cuteribs/shadowsocks-libev:v2.5.6 \
/ss/ss-server -s 0.0.0.0 -p 8080 -m rc4-md5 -k [PASSWORD] -t 120 -u
```

### SS Local
```
docker run -d
--name ss-local1
-p 138:8338
-p 138:8338/udp
cuteribs/shadowsocks-libev:v2.5.6 \
/ss/ss-local -s [SS-SERVER] -p 181 -b 0.0.0.0 -l 8338 -m rc4-md5 -k [PASSWORD] -t 120 -u
```
