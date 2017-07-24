### Run as HTTP
```shell
docker run -d \
    -p 80:80 \
    -p 6800:6800 \
    -v /data/download:/data/download \
    -e Secret=cuteribs \
    cuteribs/aria2
```

### Run as HTTPS
```shell
cp ssl.key ssl.crt ssl.pem /data/crt/

docker run -d \
    -p 443:443 \
    -p 6800:6800 \
    -v /data/download:/data/download \
    -v /data/crt:/data/crt \
    -e Secret=cuteribs \
    cuteribs/aria2
```