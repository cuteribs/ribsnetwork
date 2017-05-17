### KCP Server
```
docker run -d \
--name kcp-server1 \
-p 191:29900/udp \
--link ss-server1:ss-server \
cuteribs/kcptun:20161207 \
/kcptun/server_linux_amd64 -l :29900 -t ss-server:8080 -mode fast -crypt none -nocomp -dscp 46
```

### KCP Client
```
docker run -d \
--name kcp-client1 \
p- 180:12948 \
cuteribs/kcptun:20161207 \
/kcptun/client_linux_amd64 -l :12948 -r [kcp-server]:191 -mode fast -crypt none -nocomp -dscp 46
```
