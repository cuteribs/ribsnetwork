### iperf3 Server
```
docker run -d \
--name iperf3-server1 \
-p 5201:5201 \
cuteribs/iperf3 \
-s
```

### iperf3 Client
```
docker run -d
--name iperf3-client1
cuteribs/iperf3 \
-c iperf.server.host [-p port number]
```
