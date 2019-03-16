### homebridge on alpine docker image
```
docker run -d --name cuteribs-homebridge --restart net=host -v /docker/homebridge:/root/.homebridge cuteribs/homebridge
```