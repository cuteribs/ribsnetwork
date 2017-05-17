```
docker run \
-e Time="* 6 * * *" \        # update at 06:00 everyday
-e Token="22222,xxxxxxxxxxxxxxxxxxxx" \          # login token for dnspod.cn
-e Domain="mydomain.com" \          # domain name
-e RecordId="222222222" \          # domain record ID
-e RecordLineId="0" \          # domain record line ID, 0 as default line ID
-e SubDomain \          # sub domain name
cuteribs/dnspod
```
