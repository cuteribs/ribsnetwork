### forwards socks5 privoxy to http
```
docker run -d \
-e SOCKS5=1080 \
-e HTTP=8123 \
--link [SOCKS Container]:forward-server \
cuteribs/privoxy
```
